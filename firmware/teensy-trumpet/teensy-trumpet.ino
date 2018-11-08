/* Trumpet Robot Firmware: Teesny
 * Runs on Teensy 3.2 port
 * Connect Raspberry PI UART pins to Teensy Pins 7, 8 (that's Serial 3 RX/TX)
 * Connect servos to pins 4, 5, 6 (defined below)
 */

/* Protocol:
 * Ln - Set LED mode (0 = off, 1 = on, 2 = rapid, 3 = burst, 4 = slow)
 * Ss,nnn - Set servo s to nnn degrees (s=0/1/2, nnn=0..180)
 * Fs - Set fingers to the given state (0..6)
 * A1 - Enable auto-fingers
 * A0 - Disable auto-fingers
 * X - disable servos
 * Uf,nnn - Set finger f up value to nnn degrees
 * Df,nnn - Set finger f down value to nnn degrees
 */
 
#include <Servo.h> 

#define Raspberry Serial3
#define LED 13
#define NUM_SERVOS 3
#define FINGER_COMBINATIONS 7
#define FINGER_UP_TIMEOUT 300
#define ENABLE_USB_SERIAL 1

const int servoPins[] = {4, 5, 6};
int servoUpValues[] = {120, 60, 60};
int servoDownValues[] = {60, 120, 120};

Servo servos[NUM_SERVOS];
bool fingerState[] = {false, false, false};
unsigned long fingerReleaseTimes[] = {0, 0, 0};
bool autoFingers = true;
bool fingerMap[][NUM_SERVOS] = {
  /*0: */{false, false, false},
  /*1: */{false, true,  false},
  /*2: */{true,  false, false},
  /*3: */{false, false, true },
  /*4: */{false, true,  true },
  /*5: */{true,  false, true },
  /*6: */{true,  true,  true },
};

int ledOnTime = 200;
int ledOffTime = 800;
bool ledState = false;
unsigned int lastLedUpdate = 0;

void setup() {
#if ENABLE_USB_SERIAL
  Serial.begin(115200);
#endif
  Raspberry.begin(115200);
  pinMode(LED, OUTPUT);   
  Raspberry.println("INIT");
}

inline bool validServo(int idx) {
  return idx >= 0 && idx < NUM_SERVOS;
}

inline bool validAngle(int angle) {
  return angle >= 0 && angle <= 180;
}

inline bool validFingers(int value) {
  return value >= 0 && value < FINGER_COMBINATIONS;
}

void invalidArgs() {
#if ENABLE_USB_SERIAL
  Serial.println("E1 Invalid args");
#endif
  Raspberry.println("E1 Invalid args");
}

int noteToFingers(int value) {
  int baseTones[] = { 58, 58+7, 58+12, 58+12+4, 58+12+7, 58+12+10, 58+12+12 };
  for (unsigned int i = 0; i < sizeof(baseTones)/sizeof(baseTones[0]); i++) {
    int delta = baseTones[i] - value;
    if (validFingers(delta)) {
      return delta;
    }
  }
 
  return 0;
}

void updateFinger(int finger, bool state) {
  fingerState[finger] = state;
  if (state) {
    servos[finger].attach(servoPins[finger]);
    servos[finger].write(servoDownValues[finger]);
  } else {
    servos[finger].write(servoUpValues[finger]);
    fingerReleaseTimes[finger] = millis();
  }
}

void setFingers(int value) {
  bool *newState = fingerMap[value];
  for (int i = 0; i < NUM_SERVOS; i++) {
    if (fingerState[i] != newState[i]) {
      updateFinger(i, newState[i]);
    }
  }
}

void checkReleasedFingers() {
  for (int i = 0; i < NUM_SERVOS; i++) {
    long timeSinceRelease = millis() - fingerReleaseTimes[i];
    if (!fingerState[i] && fingerReleaseTimes[i] && timeSinceRelease > FINGER_UP_TIMEOUT) {
      servos[i].detach();
      fingerReleaseTimes[i] = 0;
    }
  }
}

void autoFingersCommand(String args) {
  autoFingers = (bool)args.toInt();
}

void setFingersDownCommand(String args) {
  int finger = 0;
  int value = 0;
  int res = sscanf(args.c_str(), "%d,%d", &finger, &value);
  if (res == 2 && validServo(finger) && validAngle(value)) {
    servoDownValues[finger] = value;
  } else {
    invalidArgs();
  }
}

void setFingersUpCommand(String args) {
  int finger = 0;
  int value = 0;
  int res = sscanf(args.c_str(), "%d,%d", &finger, &value);
  if (res == 2 && validServo(finger) && validAngle(value)) {
    servoUpValues[finger] = value;
  } else {
    invalidArgs();
  }  
}

void ledCommand(String args) {
  int value = args.toInt();
  switch (value) {
    case 0:
      ledOnTime = 0;
      ledOffTime = 1000000;
      break;
      
    case 1:
      ledOnTime = 10000000;
      ledOffTime = 0;
      break;

    case 2:
      ledOnTime = 200;
      ledOffTime = 200;
      break;

    case 3:
      ledOnTime = 100;
      ledOffTime = 500;
      break;

    case 4:
      ledOnTime = 500;
      ledOffTime = 500;
      break;
  }
}

void servoCommand(String args) {
  int servo = 0;
  int value = 0;
  int res = sscanf(args.c_str(), "%d,%d", &servo, &value);
  if (res == 2 && validServo(servo) && validAngle(value)) {
    servos[servo].attach(servoPins[servo]);
    servos[servo].write(value);
  } else {
    invalidArgs();
  }
}

void fingersCommand(String args) {
  int value = args.toInt();
  if (validFingers(value)) {
    setFingers(value);
  } else {
    invalidArgs();
  }
}

void detachServos(String args) {
  for (int i = 0; i < NUM_SERVOS; i++) {
    servos[i].detach();
  }
}

void processCommand(String cmd) {
  // Remove trailing "\r"
  if (cmd.endsWith("\r")) {
    cmd = cmd.remove(cmd.length() - 1);
  }
  String args = cmd.substring(1);
  switch (cmd.charAt(0)) {
  case 'A':
    autoFingersCommand(args);
    break;

  case 'D':
    setFingersDownCommand(args);
    break;

  case 'F':
    fingersCommand(args);
    break;

  case 'L':
    ledCommand(args);
    break;
    
  case 'S':
    servoCommand(args);
    break;

  case 'U':
    setFingersUpCommand(args);
    break;

  case 'X':
    detachServos(args);
    break;
    
  default:
#if ENABLE_USB_SERIAL
    Serial.print("E0 Unknown command: ");
    Serial.println(cmd);
#endif
  }
}

void updateLed() {
  int delta = millis() - lastLedUpdate;
  if (ledState && delta > ledOnTime) {
    ledState = false;
    digitalWrite(LED, LOW);
    lastLedUpdate = millis();
  }
  else if (!ledState && delta > ledOffTime) {
    ledState = true;
    digitalWrite(LED, HIGH);
    lastLedUpdate = millis();
  }
}

void processMIDI() {
  int type = usbMIDI.getType();
  int channel = usbMIDI.getChannel();
  int data1 = usbMIDI.getData1();
  int data2 = usbMIDI.getData2();

  if (autoFingers) {
    if (type == usbMIDI.NoteOn && data2 > 0) {
      setFingers(noteToFingers(data1));
    }
    if ((type == usbMIDI.NoteOn && data2 == 0) 
      || (type == usbMIDI.NoteOff)
      || (type == usbMIDI.SystemReset)) {
      setFingers(0);
    }
  }
  
  String buf = "M";
  buf += type | (channel - 1);
  buf += ",";
  buf += data1;
  buf += ",";
  buf += data2;
  Raspberry.println(buf);
#if ENABLE_USB_SERIAL
  Serial.println(buf);
#endif
}

int i = 0;
void loop() {
  if (Raspberry.available()) {
    processCommand(Raspberry.readStringUntil('\n'));
  }
#if ENABLE_USB_SERIAL
  if (Serial.available()) {
    processCommand(Serial.readStringUntil('\n'));
  }
#endif
  if (usbMIDI.read()) {
    processMIDI();
  }
  checkReleasedFingers();
  updateLed();
}

