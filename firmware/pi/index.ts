import * as express from 'express';
import * as socket from 'socket.io';
import { Server } from 'http';
import * as SerialPort from 'serialport';
import * as Readline from '@serialport/parser-readline';
import { spawn } from 'child_process';

const port = process.env.TRUMPET_PORT || 3000;
const serialDevice = process.env.SERIAL_PORT || '/dev/serial0';
const chromeCommand = process.env.CHROME_BINARY || 'chromium-browser';

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
  const child = spawn(chromeCommand, [
    '--headless',
    '--remote-debugging-port=9222',
    `http://localhost:${port}/`,
  ]);
  child.stdout.pipe(process.stdout);
  child.stderr.pipe(process.stderr);
});

const serialPort = new SerialPort(serialDevice, { baudRate: 115200 });
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
