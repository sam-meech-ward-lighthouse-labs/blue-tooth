module.exports = function(Characteristic) {

  const StatusCharacteristic = Object.create(Characteristic);

  StatusCharacteristic.start = function(characteristic) {
    this.init({
      uuid: 'aa9e791f-e9e4-414c-a8d6-fc9dd6fd2c17',
      properties: ['notify'],
      descriptors: [
        {
          uuid: '2901',
          value: 'Status Message'
        }
      ]
    });

    characteristic.on('status', statusChanged);
  };

  function statusChanged(status) {
    console.log(`status ${status}`);
  }

  return StatusCharacteristic;
}