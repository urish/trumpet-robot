(async function() {
  const midi = await navigator.requestMIDIAccess();
  const midiOutput = Array.from(midi.outputs.values())[0];
  const velocity = 60;
  const NOTE_OFF = 0x80;
  const NOTE_ON = 0x90;

  async function delay(seconds) {
    await new Promise(resolve => setTimeout(resolve, seconds * 1000));
  }

  function noteOn(idx, velocity) {
    midiOutput.send([NOTE_ON, idx, velocity]);
  }

  function noteOff(idx, velocity = 0) {
    midiOutput.send([NOTE_OFF, idx, velocity]);
  }

  async function playNote(note, seconds) {
    const octave = parseInt(note[note.length - 1]) + 1;
    const noteIdx = 'C,C#,D,D#,E,F,F#,G,G#,A,A#,B'
      .split(',')
      .indexOf(note.substr(0, note.length - 1));
    const idx = octave * 12 + noteIdx;
    midiOutput.send([NOTE_ON, idx, velocity]);
    await delay(seconds);
    midiOutput.send([NOTE_OFF, idx, velocity]);
  }

  async function melody() {
    const whole = 1;
    await playNote('A#4', whole);
    await playNote('F5', whole);
    await playNote('D#5', whole / 8);
    await delay(whole / 16);
    await playNote('D5', whole / 8);
    await playNote('C5', whole / 8);
    await delay(whole / 16);
    await playNote('A#5', whole);
    await playNote('F5', whole / 2);
    await playNote('D#5', whole / 8);
    await delay(whole / 16);
    await playNote('D5', whole / 8);
    await playNote('C5', whole / 8);
    await delay(whole / 16);
    await playNote('A#5', whole);
    await playNote('F5', whole / 2);
    await playNote('D#5', whole / 8);
    await delay(whole / 16);
    await playNote('D5', whole / 8);
    await playNote('D#5', whole / 8);
    await playNote('C5', whole);
  }

  const keyMap = {};

  for (let node of document.querySelectorAll('[data-note]')) {
    const noteIdx = parseInt(node.getAttribute('data-note'), 10);
    keyMap[node.textContent] = noteIdx;
    node.addEventListener('mousedown', () => {
      noteOn(noteIdx, velocity);
    });
    node.addEventListener('mouseup', () => {
      noteOff(noteIdx);
    });
  }

  window.addEventListener('keydown', e => {
    const noteIdx = keyMap[e.key];
    if (noteIdx) {
      noteOn(noteIdx, velocity);
    }
  });
  window.addEventListener('keyup', e => {
    const noteIdx = keyMap[e.key];
    if (noteIdx) {
      noteOn(noteIdx);
    }
  });

  window.noteOn = noteOn;
  window.noteOff = noteOff;
  window.melody = melody;
})();
