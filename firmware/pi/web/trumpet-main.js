function processMidiMessage(msg) {
  msg = msg.trim();
  if (msg[0] == 'M') {
    const [cmd, note, velocity] = msg
      .substr(1)
      .split(',')
      .map(v => parseInt(v, 10));
    console.log(cmd & 0xf0, note, velocity);
    if ((cmd & 0xf0) === 0x80) {
      noteOff(note, velocity);
    }
    if ((cmd & 0xf0) === 0x90) {
      noteOn(note, velocity);
    }
    if (cmd === 0xff) {
      allNotesOff();
    }
  } else {
    console.error('Invalid message', msg);
  }
}

const socket = io();
socket.on('midi', processMidiMessage);
