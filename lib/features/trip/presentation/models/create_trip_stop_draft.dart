class CreateTripStopDraft {
  String? locationName;
  String? locationAddress;
  double? lat;
  double? lng;
  String? googlePlaceId;

  CreateTripStopDraft({
    this.locationName,
    this.locationAddress,
    this.lat,
    this.lng,
    this.googlePlaceId,
  });
}