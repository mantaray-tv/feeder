class LazyLoadChunkStore {
  constructor (length, pieceLength, engine) {
    this.length = length
    this.pieceLength = pieceLength
    this.chunkLength = Math.ceil(length / pieceLength)
    this.engine = engine
  }

  put (index, buf, cb) {
    throw new Error('put not implemented')
  }

  get (index, opts, cb) {
    if (typeof opts === 'function') return this.get(index, {}, opts)
    opts.offset = opts.offset || 0
    opts.length = opts.length || this.pieceLength
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
    file.select()
    const stream = file.createReadStream({
      start: index * this.pieceLength - fileOffset + opts.offset,
      end: index * this.pieceLength - fileOffset + opts.offset + opts.length - 1
    })
    stream.on('data', (data) => {
      console.log(`get ${index} ${opts.offset} ${opts.length}`, data)
      cb(null, data)
    })
  }

  close (cb) {
    cb()
  }

  destroy (cb) {
    this.engine.destroy(cb)
  }
}

export default LazyLoadChunkStore
