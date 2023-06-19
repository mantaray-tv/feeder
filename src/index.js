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
  dispose: (key, value) => {
    value.engine.destroy()
    value.client.destroy()
    value.preloadedStore.reset()
  }
})

const sse = new ReconnectingEventSource(C.COORDINATOR_URL)

sse.addEventListener('message', async (event) => {
  const { infoHash } = JSON.parse(event.data)
  const engine = torrentEngine(infoHash)
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
