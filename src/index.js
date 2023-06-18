import WebTorrent from 'webtorrent'
import torrentEngine from 'torrent-stream'
import LazyLoadChunkStore from './chunk-store.js'

const infoHash = '23f10a3383cce0a8f45480b24c838923cf84aff5'

const client = new WebTorrent()
const engine = torrentEngine(infoHash)

engine.on('ready', async () => {
  const meta = engine.torrent.info
  const preloadedStore = new LazyLoadChunkStore(meta.length, meta['piece length'], engine)

  client.seed(null, {
    metadata: meta,
    infoHash,
    preloadedStore
  }, (torrent) => {
    console.log(`Torrent info hash: ${torrent.infoHash} ${torrent.magnetURI}`)
  })
})
