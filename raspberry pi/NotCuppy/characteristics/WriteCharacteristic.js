module.exports = function(Characteristic, onWriteCallback) {

  const WriteCharacteristic = Object.create(Characteristic);

  WriteCharacteristic.start = function() {
    this.init({
      uuid: '2D49A86E-02D8-46A9-84E8-636488225FF5',
      properties: ['writeWithoutResponse'],
      descriptors: [
        {
          uuid: '2cb6a875-4810-48d4-b044-17dcb2b75e64',
          value: 'Writer'
        }
      ]
    });
  };

  WriteCharacteristic.onWriteRequest = function(data, offset, withoutResponse, callback) {
    // let status;

    // if (data.toString() === "stop") {
    //   status = 'Stop!!!!';
    // } else if (data.toString() === "start") {
    //   status = 'Start!!!!';
    // } else {
    //   status = 'unknown ' + data.toString()
    // }

    onWriteCallback(data.toString());

    // console.log(`data: ${data}`);
    // console.log(`status: ${status}`);

    // callback(this.RESULT_SUCCESS);

    // this.emit('status', status);
  };

  return WriteCharacteristic;
}