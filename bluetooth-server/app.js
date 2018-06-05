var bleno = require('bleno');
var BlenoPrimaryService = bleno.PrimaryService;

var EchoCharacteristic = require('./characteristic');

console.log('bleno - echo');

bleno.on('stateChange', function(state) {
  console.log('on -> stateChange: ' + state);

  if (state === 'poweredOn') {
    bleno.startAdvertising('echo', ['5c292345-4e2e-41af-9210-d02dd581beff']);
  } else {
    bleno.stopAdvertising();
  }
});

bleno.on('advertisingStart', function(error) {
  console.log('on -> advertisingStart: ' + (error ? 'error ' + error : 'success'));

  if (!error) {
    bleno.setServices([
      new BlenoPrimaryService({
        uuid: '5c292345-4e2e-41af-9210-d02dd581beff',
        characteristics: [
          new EchoCharacteristic()
        ]
      })
    ]);
  }
});