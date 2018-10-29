import * as express from 'express';
import * as socket from 'socket.io';
import { Server } from 'http';
import * as SerialPort from 'serialport';
import * as Readline from '@serialport/parser-readline';

const port = process.env.TRUMPET_PORT || 3000;

const app = express();
const http = new Server(app);
const io = socket(http);

app.use(express.static('web'));

io.on('connection', socket => {
  console.log('a user connected :-)');
});

http.listen(port, () => {
  console.log(`listening on *:${port}`);
});

const serialPort = new SerialPort('/dev/serial0', { baudRate: 115200 });
const parser = serialPort.pipe(new Readline({ delimiter: '\r\n' }));
parser.on('data', msg => {
  io.emit('midi', msg);
});
