// Trumpet Playing Robot: Finger Controller
// Copyright (C) 2018, Uri Shaked. License: MIT

class ServoButton {
  constructor(options) {
    this.pin = options.pin;
    this.button = options.button;
    this.up = options.up;
    this.down = options.down;
    this.state = false;
    this.upCounter = 0;
  }

  update() {
    this.setState(digitalRead(this.button));
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

const buttons = [
  new ServoButton({ pin: D8, button: BTN1, up: 2.1, down: 0.9 }),
  new ServoButton({ pin: D9, button: BTN2, up: 2.2, down: 1.1 }),
  new ServoButton({ pin: D10, button: BTN3, up: 0.9, down: 1.9 }),
];

// Servo
function updateServos() {
  for (let i = 0; i < buttons.length; i++) {
    buttons[i].update();
  }
}

function onInit() {
  setInterval(updateServos, 20);
}
