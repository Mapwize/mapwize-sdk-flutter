part of mapwize_sdk;

/**
 * https://github.com/tobrun/flutter-mapbox-gl/blob/master/mapbox_gl_platform_interface/lib/src/location.dart
 */

class LatLng {
  double latitude, longitude;

  LatLng(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  String toString() {
    return "[Latitude:$latitude, Longitude:$longitude]";
  }

  dynamic toJson() {
    return <String,double>{
      "latitude": latitude,
      "longitude": longitude
    };
  }

}

class LatLngFloor {
  double latitude, longitude, floor;

  LatLngFloor(double latitude, double longitude, double floor) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.floor = floor;
  }

  String toString() {
    return "[Latitude:$latitude, Longitude:$longitude, Floor:$floor]";
  }

  dynamic toJson() {
    return <String,double>{
      "latitude": latitude,
      "longitude": longitude,
      "floor": floor
    };
  }

}

class Floor {
  double number;
  String name;

  Floor(double number, String name) {
    this.number = number;
    this.name = name;
  }

  String toString() {
    return "[Number:$number, Name:$name]";
  }
}