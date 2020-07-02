part of mapwize_sdk;

/**
 * https://github.com/tobrun/flutter-mapbox-gl/blob/master
 */

class MethodChannelMapwize extends MapwizePlatform {
  MethodChannel _channel;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'map#onMapLoaded':
        onMapLoadedPlatform(null);
        break;
      case 'map#onMapClick':
        final double latitude = call.arguments['latitude'];
        final double longitude = call.arguments['longitude'];
        final double floor = call.arguments['floor'];
        onMapClickPlatform(
            {'latLngFloor': LatLngFloor(latitude, longitude, floor)});
        break;
      case 'map#onFloorsChanged':
        final List floorsArg = call.arguments['floors'];
        List<Floor> floors = List();
        floorsArg.asMap().forEach((key, value) {
          double number = value['number'].toDouble();
          String name = value['name'];
          Floor floor = Floor(number, name);
          floors.add(floor);
        });
        onFloorsChangePlatform(floors);
        break;
      case 'map#onFloorChanged':
        if (call.arguments == null) {
          onFloorChangePlatform(null);
        }
        else {
          final Map<dynamic,dynamic> floorArg = call.arguments['floor'];
          double number = floorArg['number'].toDouble();
          String name = floorArg['name'];
          onFloorChangePlatform(Floor(number, name));
        }
        break;
      case 'map#onVenueEnter':
        debugPrint("Debug ON VENUE ENTER");
        if (call.arguments == null) {
          debugPrint("Debug ON VENUE ENTER");
          onVenueEnterPlatform(null);
        }
        else {
          debugPrint(call.arguments['venue']);
          json.decode(call.arguments['venue']);
          debugPrint("COUCOU ${json.decode(call.arguments['venue'])}");
          Venue venue = Venue.fromJson(json.decode(call.arguments['venue']));
          debugPrint("Venue venue $venue");
          onVenueEnterPlatform(venue);
        }
        break;
      default:
        throw MissingPluginException();
    }
  }

  @override
  Future<void> initPlatform(int id) async {
    assert(id != null);
    _channel = MethodChannel('plugins.flutter.io/mapwize_sdk_$id');
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Widget buildView(
      Map<String, dynamic> creationParams,
      Function onPlatformViewCreated) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.flutter.io/mapwize_sdk',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.flutter.io/mapwize_sdk',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  @override
  Future<void> setFloor(double floor) async {
    return await _channel.invokeMethod("map#setFloor", <String, dynamic>{
      "floorNumber": floor
    });
  }

  @override
  Future<void> addImage(String name, Uint8List bytes,
      [bool sdf = false]) async {
    try {
      return await _channel.invokeMethod('style#addImage', <String, Object>{
        "name": name,
        "bytes": bytes,
        "length": bytes.length,
        "sdf": sdf
      });
    } on PlatformException catch (e) {
      return new Future.error(e);
    }
  }

  @override
  Future<List<Symbol>> addSymbols(List<SymbolOptions> options, [List<Map> data]) async {
    final List<dynamic> symbolIds = await _channel.invokeMethod(
      'symbols#addAll',
      <String, dynamic>{
        'options': options.map((o) => o.toJson()).toList(),
      },
    );
    final List<Symbol> symbols = symbolIds.asMap().map(
            (i, id) => MapEntry(
            i,
            Symbol(
                id,
                options.elementAt(i),
                data != null && data.length > i ? data.elementAt(i) : null
            )
        )
    ).values.toList();

    return symbols;
  }

  @override
  Future<LatLng> getSymbolLatLng(Symbol symbol) async{
    Map mapLatLng =
    await _channel.invokeMethod('symbol#getGeometry', <String, dynamic>{
      'symbol': symbol._id,
    });
    LatLng symbolLatLng =
    new LatLng(mapLatLng['latitude'], mapLatLng['longitude']);
    return symbolLatLng;
  }

  @override
  Future<void> removeSymbols(Iterable<String> ids) async {
    await _channel.invokeMethod('symbols#removeAll', <String, dynamic>{
      'symbols': ids.toList(),
    });
  }

  @override
  Future<Line> addLine(LineOptions options, [Map data]) async {
    final String lineId = await _channel.invokeMethod(
      'line#add',
      <String, dynamic>{
        'options': options.toJson(),
      },
    );
    return Line(lineId, options, data);
  }

  @override
  Future<void> updateLine(Line line, LineOptions changes) async {
    await _channel.invokeMethod('line#update', <String, dynamic>{
      'line': line.id,
      'options': changes.toJson(),
    });
  }

  @override
  Future<List<LatLng>> getLineLatLngs(Line line) async{
    List latLngList =
    await _channel.invokeMethod('line#getGeometry', <String, dynamic>{
      'line': line._id,
    });
    List<LatLng> resultList = [];
    for (var latLng in latLngList) {
      resultList.add(LatLng(latLng['latitude'], latLng['longitude']));
    }
    return resultList;
  }

  @override
  Future<void> removeLine(String lineId) async {
    await _channel.invokeMethod('line#remove', <String, dynamic>{
      'line': lineId,
    });
  }

}