

class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates({required this.longitude, required this.latitude});

  Coordinates.fromData(Map<String, dynamic> data)
      : latitude = data['latitude'],
        longitude = data['longitude'];

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
