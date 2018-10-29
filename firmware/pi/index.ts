import * as express from 'express';
import * as socket from 'socket.io';
import { Server } from 'http';
import * as SerialPort from 'serialport';
import * as Readline from '@serialport/parser-readline';

const port = process.env.TRUMPET_PORT || 3000;

const app = express();
const http = new Server(app);
const io = socket(http);
const servoSetupCommands = ['U0,100', 'D0,170', 'U1,150', 'D1,80', 'U2,155', 'D2,90'];

app.use(express.static('web'));

io.on('connection', socket => {
  console.log('a user connected :-)');
  socket.on('command', msg => {
    serialPort.write(msg + '\n');
  });
});

http.listen(port, () => {
  console.log(`listening on *:${port}`);
});

const serialPort = new SerialPort('/dev/serial0', { baudRate: 115200 });
const parser = serialPort.pipe(new Readline({ delimiter: '\r\n' }));
parser.on('data', msg => {
  if (msg === 'INIT') {
    console.log('Teensy connected!');
    for (const cmd of servoSetupCommands) {
      serialPort.write(cmd + '\n');
    }
    serialPort.write('L2\n');
  } else {
    io.emit('midi', msg);
  }
});
