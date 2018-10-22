// Trumpet Playing Robot: Finger Controller
// Copyright (C) 2018, Uri Shaked. License: MIT

let buttonsEnabled = true;

class FingerController {
  constructor(options) {
    this.pin = options.pin;
    this.button = options.button;
    this.up = options.up;
    this.down = options.down;
    this.state = false;
    this.upCounter = 0;
  }

  update() {
    if (buttonsEnabled) {
      this.setState(digitalRead(this.button));
    }
    if (this.state) {
      digitalPulse(this.pin, HIGH, this.down);
      this.upCounter = 0;
    } else {
      if (this.upCounter < 3) {
        digitalPulse(this.pin, HIGH, this.up);
      }
      this.upCounter++;
    }
  }

  setState(value) {
    this.state = value;
  }
}

const fingers = [
  new FingerController({ pin: D8, button: BTN1, up: 2.1, down: 0.9 }),
  new FingerController({ pin: D9, button: BTN2, up: 2.2, down: 1.1 }),
  new FingerController({ pin: D10, button: BTN3, up: 0.9, down: 1.9 }),
];

function updateServos() {
  for (let i = 0; i < fingers.length; i++) {
    fingers[i].update();
  }
}

const sequence = 'L2 E F G F E D L4 E D E F E'.split(' ');
const noteMap = {
  D: [0, 2],
  E: [0],
  F: [2],
  G: [],
};
function playSequence() {
  if (!buttonsEnabled) {
    return;
  }

  buttonsEnabled = false;
  let wholeLength = 800;
  let noteLength = wholeLength / 4;
  let time = 0;
  for (const note of sequence) {
    if (note[0] === 'L') {
      noteLength = wholeLength / parseInt(note.substr(1));
    }
    if (noteMap[note]) {
      const noteFingers = noteMap[note];
      setTimeout(
        function(noteFingers) {
          for (let i = 0; i < fingers.length; i++) {
            fingers[i].state = noteFingers.indexOf(i) >= 0;
          }
          updateServos();
        }.bind(this, noteFingers),
        time,
      );
      time += noteLength;
    }
  }
  setTimeout(() => {
    buttonsEnabled = true;
  }, time);
}

function onInit() {
  setInterval(updateServos, 20);
  setWatch(playSequence, BTN4, { repeat: true, edge: 'rising', debounce: 25 });
}
