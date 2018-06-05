module.exports = function(Characteristic) {

  const secret = '12345';

  const WriteCharacteristic = Object.create(Characteristic);

  WriteCharacteristic.start = function() {
    this.init({
      uuid: 'd271',
      properties: ['write'],
      descriptors: [
        {
          uuid: '2901',
          value: 'Writer'
        }
      ]
    });
  };

  WriteCharacteristic.onWriteRequest = function(data, offset, withoutResponse, callback) {
    let status;

    if (data.toString() === secret) {
      status = 'do thing';
    } else {
      status = 'invalid code';
    }

    console.log(`data: ${data}`);
    console.log(`status: ${status}`);

    callback(this.RESULT_SUCCESS);

    this.emit('status', status);
  };

  return WriteCharacteristic;
}