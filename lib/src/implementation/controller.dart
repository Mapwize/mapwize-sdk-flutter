part of mapwize_sdk;

typedef void OnMapLoadedCallback();
typedef void OnMapClickCallback(LatLngFloor latLngFloor);
typedef void OnFloorsChangeCallback(List<Floor> floors);
typedef void OnFloorChangeCallback(Floor floor);

class MapwizeMapController extends ChangeNotifier {
  MapwizeMapController._(this._id,
      {this.onMapLoadedCallback,
        this.onMapClickCallback,
        this.onFloorsChangeCallback,
        this.onFloorChangeCallback})
      : assert(_id != null) {

    MapwizePlatform.getInstance(_id).onMapLoadedPlatform.add((_) {
      if (onMapLoadedCallback != null) {
        onMapLoadedCallback();
      }
    });

    MapwizePlatform.getInstance(_id).onMapClickPlatform.add((dict) {
      if (onMapClickCallback != null) {
        onMapClickCallback(dict['latLngFloor']);
      }
    });

    MapwizePlatform.getInstance(_id).onFloorsChangePlatform.add((floors) {
      if (onFloorsChangeCallback != null) {
        onFloorsChangeCallback(floors);
      }
    });

    MapwizePlatform.getInstance(_id).onFloorChangePlatform.add((floor) {
      if (onFloorChangeCallback != null) {
        onFloorChangeCallback(floor);
      }
    });
  }

  static Future<MapwizeMapController> init(
      int id,
      {OnMapLoadedCallback onMapLoadedCallback,
        OnMapClickCallback onMapClickCallback,
        OnFloorsChangeCallback onFloorsChangeCallback,
        OnFloorChangeCallback onFloorChangeCallback}) async {
    assert(id != null);
    await MapwizePlatform.getInstance(id).initPlatform(id);
    return MapwizeMapController._(id,
        onMapLoadedCallback: onMapLoadedCallback,
        onMapClickCallback: onMapClickCallback,
        onFloorsChangeCallback: onFloorsChangeCallback,
        onFloorChangeCallback: onFloorChangeCallback
    );
  }

  final OnMapLoadedCallback onMapLoadedCallback;
  final OnMapClickCallback onMapClickCallback;
  final OnFloorsChangeCallback onFloorsChangeCallback;
  final OnFloorChangeCallback onFloorChangeCallback;

  final int _id; //ignore: unused_field

  Widget buildView(
      Map<String, dynamic> creationParams,
      Function onPlatformViewCreated) {
    return MapwizePlatform.getInstance(_id)
        .buildView(creationParams, onPlatformViewCreated);
  }

  Future<void> addImage(String name, Uint8List bytes, [bool sdf = false]) {
    return MapwizePlatform.getInstance(_id).addImage(name, bytes, sdf);
  }

  Set<Symbol> get symbols => Set<Symbol>.from(_symbols.values);
  final Map<String, Symbol> _symbols = <String, Symbol>{};

  Future<Symbol> addSymbol(SymbolOptions options, [Map data]) async {
    List<Symbol> result = await addSymbols([options], [data]);
    debugPrint("$result");
    return result.first;
  }

  Future<List<Symbol>> addSymbols(List<SymbolOptions> options, [List<Map> data]) async {
    final List<SymbolOptions> effectiveOptions = options.map(
            (o) => SymbolOptions.defaultOptions.copyWith(o)
    ).toList();

    final symbols = await MapwizePlatform.getInstance(_id).addSymbols(effectiveOptions, data);
    symbols.forEach((s) => _symbols[s.id] = s);
    notifyListeners();
    return symbols;
  }

  Set<Line> get lines => Set<Line>.from(_lines.values);
  final Map<String, Line> _lines = <String, Line>{};

  Future<LatLng> getSymbolLatLng(Symbol symbol) async {
    assert(symbol != null);
    assert(_symbols[symbol.id] == symbol);
    final symbolLatLng =
    await MapwizePlatform.getInstance(_id).getSymbolLatLng(symbol);
    notifyListeners();
    return symbolLatLng;
  }

  Future<void> removeSymbol(Symbol symbol) async {
    assert(symbol != null);
    assert(_symbols[symbol.id] == symbol);
    await _removeSymbols([symbol.id]);
    notifyListeners();
  }

  Future<void> removeSymbols(Iterable<Symbol> symbols) async {
    assert(symbols.length > 0);
    symbols.forEach((s) {
      assert(_symbols[s.id] == s);
    });

    await _removeSymbols(symbols.map((s) => s.id));
    notifyListeners();
  }

  Future<void> clearSymbols() async {
    assert(_symbols != null);
    final List<String> symbolIds = List<String>.from(_symbols.keys);
    _removeSymbols(symbolIds);
    notifyListeners();
  }

  Future<void> _removeSymbols(Iterable<String> ids) async {
    await MapwizePlatform.getInstance(_id).removeSymbols(ids);
    _symbols.removeWhere((k, s) => ids.contains(k));
  }

  Future<Line> addLine(LineOptions options, [Map data]) async {
    final LineOptions effectiveOptions =
    LineOptions.defaultOptions.copyWith(options);
    final line =
    await MapwizePlatform.getInstance(_id).addLine(effectiveOptions);
    _lines[line.id] = line;
    notifyListeners();
    return line;
  }

  Future<List<LatLng>> getLineLatLngs(Line line) async {
    assert(line != null);
    assert(_lines[line.id] == line);
    final lineLatLngs =
    await MapwizePlatform.getInstance(_id).getLineLatLngs(line);
    notifyListeners();
    return lineLatLngs;
  }

  Future<void> removeLine(Line line) async {
    assert(line != null);
    assert(_lines[line.id] == line);
    await _removeLine(line.id);
    notifyListeners();
  }

  Future<void> clearLines() async {
    assert(_lines != null);
    final List<String> lineIds = List<String>.from(_lines.keys);
    for (String id in lineIds) {
      await _removeLine(id);
    }
    notifyListeners();
  }

  Future<void> _removeLine(String id) async {
    await MapwizePlatform.getInstance(_id).removeLine(id);
    _lines.remove(id);
  }

}