const bleno = require('bleno');

const uuid = 'C383E0DD-644D-473B-B280-DCD260484EA0';
const major = 10; // 0x0000 - 0xffff
const minor = 20; // 0x0000 - 0xffff
const measuredPower = -59; // -128 - 127

function startAdvertising() {
  bleno.startAdvertisingIBeacon(uuid, major, minor, measuredPower);
}

console.log('iBeacon');

bleno.on('stateChange', function(state) {
  console.log('on -> stateChange: ' + state);

  if (state === 'poweredOn') {
    startAdvertising();
  } else {
    bleno.stopAdvertising();
  }
});

bleno.on('advertisingStart', function() {
  console.log('on -> advertisingStart');
});

bleno.on('advertisingStop', function() {
  console.log('on -> advertisingStop');
});