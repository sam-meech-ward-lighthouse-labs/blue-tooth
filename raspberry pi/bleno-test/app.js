const bleno = require('bleno');

const Characteristic = require('./characteristics/Characteristic')(bleno);
const PrimaryService = require('./characteristics/PrimaryService')(bleno);

const WriteCharacteristic = require('./characteristics/WriteCharacteristic')(Characteristic);
const StatusCharacteristic = require('./characteristics/StatusCharacteristic')(Characteristic);


const writeCharacteristic = Object.create(WriteCharacteristic);
writeCharacteristic.start();
const statusCharacteristic = Object.create(StatusCharacteristic);
statusCharacteristic.start(writeCharacteristic);

const service = Object.create(PrimaryService);
service.init('d270', [writeCharacteristic, statusCharacteristic]);

bleno.on('stateChange', function(state) {
  console.log('on -> stateChange: ' + state);

  if (state === 'poweredOn') {
    bleno.startAdvertising('Test App', [service.uuid]);
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