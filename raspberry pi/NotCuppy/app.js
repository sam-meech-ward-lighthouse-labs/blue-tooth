const motors = require('./motors');

function changeMotorState(state) {
  let status;

  if (state === "stop") {
    status = 'Stop!!!!';
    motors.turnOff();
  } else if (state === "start") {
    motors.turnOn();
    status = 'Start!!!!';
  } else {
    status = 'unknown ' + state
  }

  console.log(`status: ${status}`);
}

const bleno = require('bleno');

const Characteristic = require('./characteristics/Characteristic')(bleno);
const PrimaryService = require('./characteristics/PrimaryService')(bleno);

const WriteCharacteristic = require('./characteristics/WriteCharacteristic')(Characteristic, changeMotorState);
const StatusCharacteristic = require('./characteristics/StatusCharacteristic')(Characteristic);


const writeCharacteristic = Object.create(WriteCharacteristic);
writeCharacteristic.start();
const statusCharacteristic = Object.create(StatusCharacteristic);
statusCharacteristic.start(writeCharacteristic);

const service = Object.create(PrimaryService);
service.init('A7229812-D372-495B-B51D-B54C408A3659', [writeCharacteristic, statusCharacteristic]);

bleno.on('stateChange', function(state) {
  console.log('on -> stateChange: ' + state);

  if (state === 'poweredOn') {
    bleno.startAdvertising('NotCuppy', [service.uuid]);
  } else {
    bleno.stopAdvertising();
  }
});

bleno.on('advertisingStart', function(error) {
  console.log('on -> advertisingStart: ' + (error ? 'error ' + error : 'success'));

  if (!error) {
    bleno.setServices([service]);
  }
});

bleno.on('servicesSet', function(error) {
  console.log('on -> servicesSet: ' + (error ? 'error ' + error : 'success'));
});
