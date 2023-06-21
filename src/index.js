import WebTorrent from 'webtorrent'
import torrentEngine from 'torrent-stream'
import LazyLoadChunkStore from './chunk-store.js'
import { LRUCache } from 'lru-cache'
import C from './constants.js'
import ReconnectingEventSource from 'reconnecting-eventsource'
import EventSource from 'eventsource'

global.EventSource = EventSource

const client = new WebTorrent()
const engineLRU = new LRUCache({
  max: C.MAX_NUM_PROXY,
  dispose: (value, key) => {
    console.log(`Disposing ${key}`)
    value.engine.destroy()
    value.client.destroy()
    value.preloadedStore.reset()
  }
})

const sse = new ReconnectingEventSource(C.COORDINATOR_URL)
const trackers = Array.from(new Set([
  ...(
    (
      await (
        await fetch('https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt')
      ).text()
    ).split('\n').map((tracker) => tracker.trim()).filter((tracker) => tracker.length > 0)
  ),
  'udp://tracker.openbittorrent.com:80',
  'udp://tracker.ccc.de:80',
  'udp://tracker.internetwarriors.net:1337',
  'udp://tracker.leechers-paradise.org:6969',
  'udp://tracker.coppersurfer.tk:6969',
  'udp://exodus.desync.com:6969',
  'wss://tracker.btorrent.xyz',
  'wss://tracker.openwebtorrent.com',
  'wss://tracker.fastcast.nz',
  'udp://tracker.opentrackr.org:1337',
  'udp://explodie.org:6969',
  'udp://tracker.empire-js.us:1337'
]))
globalThis.TRACKERS = trackers

sse.addEventListener('message', async (event) => {
  const { infoHash } = JSON.parse(event.data)
  if (engineLRU.get(infoHash)) return
  const engine = torrentEngine(infoHash, { trackers })
  engine.on('ready', async () => {
    const meta = engine.torrent.info
    const preloadedStore = new LazyLoadChunkStore(meta.length, meta['piece length'], engine, engineLRU)
    engineLRU.set(infoHash, {
      engine,
      client,
      preloadedStore
    })
    client.seed(null, {
      metadata: meta,
      infoHash,
      preloadedStore
    }, (torrent) => {
      console.log(`Proxying ${torrent.infoHash}`)
    })
  })
})
