(async function() {
  const AUDIO_FILE = 'audio/trumpet.mp3';

  const context = new AudioContext();

  function splitNotes(buffer, noteLength, noteCount, offset = 0) {
    const result = [];
    const channels = buffer.numberOfChannels;
    const samplesPerNote = Math.round(noteLength * buffer.sampleRate);
    const offsetSamples = Math.round(offset * buffer.sampleRate);
    const tempBuf = new Float32Array(samplesPerNote);

    for (let i = 0; i < noteCount; i++) {
      result[i] = context.createBuffer(
        channels,
        buffer.numberOfChannels * samplesPerNote,
        buffer.sampleRate,
      );
      for (let channel = 0; channel < channels; channel++) {
        buffer.copyFromChannel(tempBuf, channel, i * samplesPerNote + offsetSamples);
        result[i].copyToChannel(tempBuf, channel, 0);
      }
    }

    return result;
  }

  const response = await window.fetch(AUDIO_FILE);
  const arrayBuffer = await response.arrayBuffer();
  const trumpetBuffer = await context.decodeAudioData(arrayBuffer);
  const notes = splitNotes(trumpetBuffer, 4, 43, 0);

  function play(audioBuffer, gain) {
    const sourceNode = context.createBufferSource();
    const gainNode = context.createGain();
    gainNode.gain.value = gain;
    sourceNode.buffer = audioBuffer;
    sourceNode.connect(gainNode);
    gainNode.connect(context.destination);
    sourceNode.start();
    return gainNode;
  }

  let activeNote = null;

  async function noteOff() {
    if (activeNote) {
      activeNote.gain.exponentialRampToValueAtTime(0.00001, context.currentTime + 0.1);
      activeNote = null;
    }
  }

  async function noteOn(note, velocity) {
    if (activeNote) {
      noteOff();
    }
    if (!velocity) {
      return;
    }

    const noteIdx = note - 54;
    if (noteIdx >= 0 && noteIdx < notes.length) {
      activeNote = play(notes[note - 54], velocity / 127);
    }
  }

  window.noteOn = noteOn;
  window.noteOff = noteOff;
})();