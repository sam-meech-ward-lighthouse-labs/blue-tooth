const Gpio = require('onoff').Gpio;
const motor1 = new Gpio(17, 'out');
const motor2 = new Gpio(18, 'out');
 
function turnOn() {
  motor1.write(1);
  motor2.write(1);
}
exports.turnOn = turnOn;

function turnOff() {
  motor1.write(0);
  motor2.write(0);
}
exports.turnOff = turnOff;