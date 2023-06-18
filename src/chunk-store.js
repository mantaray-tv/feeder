class LazyLoadChunkStore {
  constructor (chunkLength, engine) {
    this.chunkLength = chunkLength
    this.engine = engine
  }

  put (index, buf, cb) {
    throw new Error('put not implemented')
  }

  get (index, opts, cb) {
    opts = opts || { offset: 0, length: this.chunkLength }
    const stream = this.engine.createReadStream({
      start: index * this.chunkLength + opts.offset,
      end: index * this.chunkLength + opts.offset + opts.length - 1
    })
    // convert stream to buffer
    const bufs = []
    stream.on('data', (data) => {
      bufs.push(data)
    })
    stream.on('end', () => {
      cb(null, Buffer.concat(bufs))
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
