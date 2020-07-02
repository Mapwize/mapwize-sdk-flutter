part of mapwize_sdk;

/// LatLng represents a geo-spatial coordinate
class LatLng {
  double latitude, longitude;

  LatLng(this.latitude, this.longitude);

  static LatLng fromJson(dynamic json) {
    return LatLng(json["latitude"], json["longitude"]);
  }

  dynamic toJson() {
    return <String,double>{
      "latitude": latitude,
      "longitude": longitude
    };
  }

  String toString() {
    return "[Latitude:$latitude, Longitude:$longitude]";
  }

}

/// LatLng represents a geo-spatial coordinate with a floor attribute in order to work with buildings.
class LatLngFloor {
  double latitude, longitude, floor;

  LatLngFloor(this.latitude, this.longitude, this.floor);

  static LatLngFloor fromJson(dynamic json) {
    return LatLngFloor(json["latitude"], json["longitude"], json["floor"]);
  }

  dynamic toJson() {
    return <String,double>{
      "latitude": latitude,
      "longitude": longitude,
      "floor": floor
    };
  }

  String toString() {
    return "[Latitude:$latitude, Longitude:$longitude, Floor:$floor]";
  }
}

/// A latitude/longitude aligned rectangle.
///
/// The rectangle conceptually includes all points (lat, lng) where
/// * lat ∈ [`southwest.latitude`, `northeast.latitude`]
/// * lng ∈ [`southwest.longitude`, `northeast.longitude`],
///   if `southwest.longitude` ≤ `northeast.longitude`,
/// * lng ∈ [-180, `northeast.longitude`] ∪ [`southwest.longitude`, 180[,
///   if `northeast.longitude` < `southwest.longitude`
class LatLngBounds {
  /// Creates geographical bounding box with the specified corners.
  ///
  /// The latitude of the southwest corner cannot be larger than the
  /// latitude of the northeast corner.
  LatLngBounds({@required this.southwest, @required this.northeast})
      : assert(southwest != null),
        assert(northeast != null),
        assert(southwest.latitude <= northeast.latitude);

  /// The southwest corner of the rectangle.
  final LatLng southwest;

  /// The northeast corner of the rectangle.
  final LatLng northeast;

  dynamic toList() {
    return <dynamic>[southwest.toJson(), northeast.toJson()];
  }

  @visibleForTesting
  static LatLngBounds fromList(dynamic json) {
    if (json == null) {
      return null;
    }
    return LatLngBounds(
      southwest: LatLng.fromJson(json[0]),
      northeast: LatLng.fromJson(json[1]),
    );
  }

  @override
  String toString() {
    return '$runtimeType($southwest, $northeast)';
  }

  @override
  bool operator ==(Object o) {
    return o is LatLngBounds &&
        o.southwest == southwest &&
        o.northeast == northeast;
  }

  @override
  int get hashCode => hashValues(southwest, northeast);
}

/// Representation of an Floor object. Number is use as order and Name as display
class Floor {
  double number;
  String name;

  Floor(this.number, this.name);

  static Floor fromJson(dynamic json) {
    return Floor(json["number"], json["name"]);
  }

  dynamic toJson() {
    return <String,dynamic>{
      "number": number,
      "name": name
    };
  }

  String toString() {
    return "[Number:$number, Name:$name]";
  }
}

class Universe {
  String id;
  String name;

  Universe(this.id, this.name);

  static Universe fromJson(dynamic json) {
    return Universe(json["_id"], json["name"]);
  }

  static List<Universe> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((e) => Universe.fromJson(e)).toList();
  }

  dynamic toJson() {
    return <String,dynamic>{
      "_id": id,
      "name": name
    };
  }

}

class Translation {
  String id;
  String title;
  String subtitle;
  String details;
  String language;

  Translation(this.id, this.title, this.subtitle, this.details, this.language);

  static Translation fromJson(dynamic json) {
    return Translation(json["_id"], json["title"], json["subTitle"], json["details"], json["language"]);
  }

  static List<Translation> fromJsonArray(List<dynamic> jsonArray) {
    debugPrint("TRANSLATIONS ${jsonArray}");
    debugPrint("${jsonArray[0]}");

    return jsonArray.map((model)=> Translation.fromJson(model)).toList();
  }

  dynamic toJson() {
    return <String,dynamic>{
      "_id": id,
      "title": title,
      "subTitle": subtitle,
      "details": details,
      "language": language
    };
  }

}

class Venue {
  String id;
  String name;
  String alias;
  String defaultLanguage;
  List<String> supportedLanguages;
  String iconUrl;
  LatLng defaultCenter;
  double defaultZoom;
  List<Translation> translations;
  List<Universe> universes;
  bool areQrcodesDeployed;
  bool areIbeaconsDeployed;
  Map<String, dynamic> data;
  Map<String, dynamic> indoorLocationProviders;
  double defaultFloor;
  double defaultBearing;
  double defaultPitch;

  Venue(this.id, this.name, this.alias, this.defaultLanguage, this.supportedLanguages, this.iconUrl,
      this.defaultCenter, this.defaultZoom, this.translations, this.universes,
      this.areQrcodesDeployed, this.areIbeaconsDeployed, this.data, this.indoorLocationProviders,
      this.defaultFloor, this.defaultBearing, this.defaultPitch);

  static Venue fromJson(dynamic json) {
    debugPrint("JSON ${json["_id"].runtimeType}");
    debugPrint("JSON ${json["name"].runtimeType}");
    debugPrint("JSON ${json["alias"].runtimeType}");
    debugPrint("JSON ${json["defaultLanguage"].runtimeType}");
    debugPrint("JSON ${json["supportedLanguages"].runtimeType}");
    debugPrint("JSON ${json["iconUrl"].runtimeType}");
    debugPrint("JSON LATLNG FROM ${LatLng.fromJson(json["defaultCenter"]).runtimeType}");
    debugPrint("JSON zoom ${json["defaultZoom".runtimeType]}");
    debugPrint("JSON TRANSLATION FROM ${Translation.fromJsonArray(json["translations"]).runtimeType}");
    debugPrint("JSON UNIVERSE FROM ${Universe.fromJsonArray(json["universes"]).runtimeType}");
    debugPrint("JSON qrcode ${json["areQrcodesDeployed"].runtimeType}");
    debugPrint("JSON beacon ${json["areIbeaconsDeployed"].runtimeType}");
    debugPrint("JSON data ${json["data"].runtimeType}");
    debugPrint("JSON providers ${json["indoorLocationProviders"].runtimeType}");
    debugPrint("JSON floor ${json["defaultFloor"].runtimeType}");
    debugPrint("JSON bearing ${json["defaultBearing"].runtimeType}");
    debugPrint("JSON pitch ${json["defaultPitch"].runtimeType}");

    debugPrint("return");

    Venue v = Venue(
        json["_id"],
        json["name"],
        json["alias"],
        json["defaultLanguage"],
        List<String>.from(json["supportedLanguages"]),
        json["iconUrl"],
        LatLng.fromJson(json["defaultCenter"]),
        json["defaultZoom"],
        Translation.fromJsonArray(json["translations"]),
        Universe.fromJsonArray(json["universes"]),
        json["areQrcodesDeployed"],
        json["areIbeaconsDeployed"],
        json["data"],
        json["indoorLocationProviders"],
        json["defaultFloor"],
        json["defaultBearing"],
        json["defaultPitch"]
    );

    debugPrint("return again");
    return v;
  }

  dynamic toJson() {
    return <String, dynamic>{
      "_id": id,
      "name": name,
      "alias": alias,
      "defaultLanguage": defaultLanguage,
      "supportedLanguages": supportedLanguages,
      "iconUrl": iconUrl,
      "defaultCenter": defaultCenter.toJson(),
      "defaultZoom": defaultZoom,
      "translations": translations.map((e) => e.toJson()).toList(),
      "universes": universes.map((e) => e.toJson()).toList(),
      "areQrcodesDeployed": areQrcodesDeployed,
      "areIbeaconsDeployed": areIbeaconsDeployed,
      "data": data,
      "indoorLocationProviders": indoorLocationProviders,
      "defaultFloor": defaultFloor,
      "defaultBearing": defaultBearing,
      "defaultPitch": defaultPitch
    };
  }
}

class Place {
  String id;
  String venueId;
  String name;
  String alias;
  String iconUrl;
  String fillColor;
  String strokeColor;
  double fillOpacity;
  double strokeOpacity;
  int strokeWidth;
  int order;
  double floor;
  bool isSearchable;
  bool isVisible;
  bool isClickable;
  List<Universe> universes;
  List<Translation> translations;
  bool markerDisplay;
  String placeTypeId;
  Map<String, dynamic> data;

  Place(
    this.id,
    this.venueId,
    this.name,
    this.alias,
    this.iconUrl,
    this.fillColor,
    this.strokeColor,
    this.fillOpacity,
    this.strokeOpacity,
    this.strokeWidth,
    this.order,
    this.floor,
    this.isSearchable,
    this.isVisible,
    this.isClickable,
    this.universes,
    this.translations,
    this.markerDisplay,
    this.placeTypeId,
    this.data,
  );

  static Place fromJson(dynamic json) {
    return Place(
      json["_id"],
      json["venueId"],
      json["name"],
      json["alias"],
      json["iconUrl"],
      json["fillColor"],
      json["strokeColor"],
      json["fillOpacity"],
      json["strokeOpacity"],
      json["strokeWidth"],
      json["order"],
      json["floor"],
      json["isSearchable"],
      json["isVisible"],
      json["isClickable"],
      Universe.fromJsonArray(json["universes"]),
      Translation.fromJsonArray(json["translations"]),
      json["markerDisplay"],
      json["placeTypeId"],
      json["data"],
    );
  }

  dynamic toJson() {
    return <String, dynamic>{
      "_id": id,
      "venueId": venueId,
      "name": name,
      "alias": alias,
      "iconUrl": iconUrl,
      "fillColor": fillColor,
      "strokeColor": strokeColor,
      "fillOpacity": fillOpacity,
      "strokeOpacity": strokeOpacity,
      "translations": translations.map((e) => e.toJson()),
      "universes": universes.map((e) => e.toJson()),
      "strokeWidth": strokeWidth,
      "order": order,
      "floor": floor,
      "isSearchable": isSearchable,
      "isVisible": isVisible,
      "isClickable": isClickable,
      "markerDisplay": markerDisplay,
      "placeTypeId": placeTypeId,
      "data": data,
    };
  }

}