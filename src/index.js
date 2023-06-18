import WebTorrent from 'webtorrent'
import fs from 'fs'
import fetchMetadata from 'bep9-metadata-dl'
import torrentEngine from 'torrent-stream'
import LazyLoadChunkStore from './chunk-store.js'

const infoHash = 'cd4712275bc68d895451977dab645d8874d353e5'

const client = new WebTorrent()
const engine = torrentEngine(infoHash)

const fetchMeta = async (arg) => {
  const data = await fetchMetadata(arg, client.dht ? { dht: client.dht } : undefined)
  // return {
  //   name: data.info.name.toString(),
  //   length: data.info.length,
  //   pieceLength: data.info['piece length'],
  //   pieces: data.info.pieces
  // }
  return data.info
}

const meta = await fetchMeta(infoHash)
const preloadedStore = new LazyLoadChunkStore(Math.ceil(meta.length / meta.pieceLength), engine)

client.seed(null, {
  metadata: meta,
  infoHash,
  preloadedStore
}, (torrent) => {
  console.log(`Torrent info hash: ${torrent.infoHash} ${torrent.magnetURI}`)
})

// client.seed('/home/kento/github/wt-test/test.txt', {
//   metadata: meta,
//   infoHash
// }, (torrent) => {
//   console.log(`Torrent info hash: ${torrent.infoHash} ${torrent.magnetURI}`)
//   // write torrent.torrentFile
// })
