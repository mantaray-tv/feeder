import { LRUCache } from 'lru-cache'
import C from './constants.js'

class LazyLoadChunkStore {
  constructor (length, pieceLength, engine, engineLRU) {
    this.length = length
    this.pieceLength = pieceLength
    this.chunkLength = Math.ceil(length / pieceLength)
    this.engine = engine
    this.engineLRU = engineLRU
    this.lru = new LRUCache({
      maxSize: C.MAX_BYTES_SELECT_PER_TORRENT,
      sizeCalculation: (value, key) => {
        return value.length
      },
      dispose: (value, key) => {
        value.deselect()
      }
    })
    engine.files.forEach((file, index) => {
      file.select()
      this.lru.set(index, file)
    })
  }

  put (index, buf, cb) {
    throw new Error('put not implemented')
  }

  get (index, opts, cb) {
    if (typeof opts === 'function') return this.get(index, {}, opts)
    opts.offset = opts.offset || 0
    opts.length = opts.length || this.pieceLength
    this.engineLRU.get(this.engine.torrent.infoHash)
    const files = this.engine.torrent.files
    let fileIndex = 0
    let fileOffset = 0
    for (let i = 0; i < files.length; i++) {
      const file = files[i]
      if (fileOffset + file.length > index * this.pieceLength) {
        fileIndex = i
        break
      }
      fileOffset += file.length
    }
    const file = this.engine.files[fileIndex]
    this.lru.get(index)
    file.select()
    const stream = file.createReadStream({
      start: index * this.pieceLength - fileOffset + opts.offset,
      end: index * this.pieceLength - fileOffset + opts.offset + opts.length - 1
    })
    stream.on('data', (data) => {
      cb(null, data)
    })
  }

  close (cb) {
    cb()
  }

  destroy (cb) {
    cb()
  }
}

export default LazyLoadChunkStore
