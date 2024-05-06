import C from './constants.js';
import ReconnectingEventSource from 'reconnecting-eventsource';
import EventSource from 'eventsource';
import { Peer } from 'peerjs-on-node';
import { spawn } from 'child-process-promise';
import getPort from 'get-port';

global.EventSource = EventSource;

const sse = new ReconnectingEventSource(C.COORDINATOR_URL);
const peer = new Peer();

sse.addEventListener('message', async (event) => {
  const { infoHash, clientSessionId } = JSON.parse(event.data);
  const conn = peer.connect(clientSessionId);

  conn.on('open', () => {
    conn.on('data', async (data) => {
      const { type } = data;
      if (type === 'requestStream') {
        const port = await getPort();
        spawn(
          'peerflix',
          [
            `magnet:?xt=urn:btih:${infoHash}&dn=%5BErai-raws%5D%20Oshi%20no%20Ko%20-%2011%20%5B1080p%5D%5BMultiple%20Subtitle%5D%20%5BENG%5D%5BPOR-BR%5D%5BSPA-LA%5D&tr=http%3A%2F%2Fnyaa.tracker.wf%3A7777%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fexodus.desync.com%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce`,
            '--vlc',
            '--',
            '-I',
            'rc',
            '--sout',
            `#transcode{vcodec=H264,threads=1,acodec=aac,soverlay}:std{access=http,mux=ts,dst=:${port}/stream.m2ts}`,
            '--no-playlist-autostart'
          ]
        );
      }
    });
  });
});
