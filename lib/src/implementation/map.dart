part of mapwize_sdk;

typedef void MapCreatedCallback(MapwizeMapController controller);

class MapwizeMap extends StatefulWidget {
  const MapwizeMap({
    Key key,
    this.apiKey,
    this.centerOnVenueId,
    this.centerOnPlaceId,
    this.onMapCreatedCallback,
    this.onMapLoadedCallback,
    this.onMapClickCallback,
    this.onFloorsChangeCallback,
    this.onFloorChangeCallback
  }) : super(key: key);

  final MapCreatedCallback onMapCreatedCallback;
  final OnMapLoadedCallback onMapLoadedCallback;
  final OnMapClickCallback onMapClickCallback;
  final OnFloorsChangeCallback onFloorsChangeCallback;
  final OnFloorChangeCallback onFloorChangeCallback;
  final String apiKey;
  final String centerOnVenueId;
  final String centerOnPlaceId;

  @override
  State<StatefulWidget> createState() => _MapwizeMapState();
}

class _MapwizeMapState extends State<MapwizeMap> {
  final Completer<MapwizeMapController> _controller =
  Completer<MapwizeMapController>();

  final MapwizePlatform _mapwizePlatform = MapwizePlatform.createInstance();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'apiKey': widget.apiKey,
      'centerOnVenueId': widget.centerOnVenueId,
      'centerOnPlaceId': widget.centerOnPlaceId,
    };
    return _mapwizePlatform.buildView(creationParams, onPlatformViewCreated);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> onPlatformViewCreated(int id) async {
    MapwizePlatform.addInstance(id, _mapwizePlatform);
    final MapwizeMapController controller = await MapwizeMapController.init(
        id,
        onMapLoadedCallback: widget.onMapLoadedCallback,
        onMapClickCallback: widget.onMapClickCallback,
        onFloorsChangeCallback: widget.onFloorsChangeCallback,
        onFloorChangeCallback: widget.onFloorChangeCallback);
    _controller.complete(controller);
    if (widget.onMapCreatedCallback != null) {
      widget.onMapCreatedCallback(controller);
    }
  }
}
