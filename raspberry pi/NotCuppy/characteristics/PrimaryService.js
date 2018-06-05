module.exports = function(service) {

  const PrimaryService = Object.create(service.PrimaryService.prototype);
  PrimaryService.init = function(uuid, characteristics) {
    service.PrimaryService.call(this, {
      uuid,
      characteristics
    });
  }

  return PrimaryService;
}