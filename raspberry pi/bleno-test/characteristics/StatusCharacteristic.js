module.exports = function(Characteristic) {

  const StatusCharacteristic = Object.create(Characteristic);

  StatusCharacteristic.start = function(characteristic) {
    this.init({
      uuid: 'd272',
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