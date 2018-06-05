var Bleacon = require('bleacon');

var uuid = 'd2bbe99b-4c77-42d8-9806-638d8deb8b54';
var major = 1;
var minor = 2;
var measuredPower = -59;

console.log('starting advertising ...');
Bleacon.startAdvertising(uuid, major, minor, measuredPower);