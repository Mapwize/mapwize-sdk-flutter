part of mapwize_sdk;

/**
 * https://github.com/tobrun/flutter-mapbox-gl/blob/master
 */

abstract class MapwizePlatform {

  static MapwizePlatform Function() createInstance =
      () => MethodChannelMapwize();

  static Map<int, MapwizePlatform> _instances = {};

  static void addInstance(int id, MapwizePlatform platform) {
    _instances[id] = platform;
  }

  static MapwizePlatform getInstance(int id) {
    return _instances[id];
  }

  Future<void> initPlatform(int id) async {
    throw UnimplementedError('initPlatform() has not been implemented.');
  }

  final ArgumentCallbacks<void> onMapLoadedPlatform = ArgumentCallbacks<void>();
  final ArgumentCallbacks<Map<String, dynamic>> onMapClickPlatform = ArgumentCallbacks<Map<String, dynamic>>();
  final ArgumentCallbacks<List<Floor>> onFloorsChangePlatform = ArgumentCallbacks<List<Floor>>();
  final ArgumentCallbacks<Floor> onFloorChangePlatform = ArgumentCallbacks<Floor>();
  final ArgumentCallbacks<Venue> onVenueEnterPlatform = ArgumentCallbacks<Venue>();

  Widget buildView(
      Map<String, dynamic> creationParams,
      Function onPlatformViewCreated) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  Future<void> setFloor(double floor) async {
    throw UnimplementedError('setFloor() has not been implemented.');
  }

  Future<void> addImage(String name, Uint8List bytes,
      [bool sdf = false]) async {
    throw UnimplementedError('addImage() has not been implemented.');
  }

  Future<List<Symbol>> addSymbols(List<SymbolOptions> options, [List<Map> data]) async {
    throw UnimplementedError('addSymbols() has not been implemented.');
  }

  Future<LatLng> getSymbolLatLng(Symbol symbol) async {
    throw UnimplementedError('getSymbolLatLng() has not been implemented.');
  }

  Future<void> removeSymbols(Iterable<String> symbolsIds) async {
    throw UnimplementedError('removeSymbol() has not been implemented.');
  }

  Future<Line> addLine(LineOptions options, [Map data]) async {
    throw UnimplementedError('addLine() has not been implemented.');
  }

  Future<List<LatLng>> getLineLatLngs(Line line) async {
    throw UnimplementedError('getLineLatLngs() has not been implemented.');
  }

  Future<void> removeLine(String lineId) async {
    throw UnimplementedError('removeLine() has not been implemented.');
  }

}