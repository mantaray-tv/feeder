import WebTorrent from 'webtorrent'
import torrentEngine from 'torrent-stream'
import LazyLoadChunkStore from './chunk-store.js'
import { LRUCache } from 'lru-cache'
import { MAX_NUM_PROXY } from '../constants.js'

const client = new WebTorrent()
globalThis.engineLRU = new LRUCache({
  max: MAX_NUM_PROXY,
  dispose: (key, value) => {
    value.destroy()
  }
})

const infoHash = 'e8bab7a37a347f30e85f932dcd15e4c0cc141aa8'
const engine = torrentEngine(infoHash)

engine.on('ready', async () => {
  const meta = engine.torrent.info
  const preloadedStore = new LazyLoadChunkStore(meta.length, meta['piece length'], engine)
  globalThis.engineLRU.set(infoHash, engine)
  client.seed(null, {
    metadata: meta,
    infoHash,
    preloadedStore
  }, (torrent) => {
    console.log(`Proxying ${torrent.infoHash}`)
  })
})
