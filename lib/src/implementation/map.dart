part of mapwize_sdk;

typedef void MapCreatedCallback(MapwizeMapController controller);

/// MapwizeMap is the widget that must be added to your flutter application in order to display the Mapwize map.
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
    this.onFloorChangeCallback,
    this.onVenueEnterCallback
  }) : super(key: key);

  /// onMapCreatedCallback called when the widget is created
  final MapCreatedCallback onMapCreatedCallback;

  /// onMapLoadedCallback called when the map is fully loaded
  final OnMapLoadedCallback onMapLoadedCallback;

  /// onMapClickCallback called when the user click on the map
  final OnMapClickCallback onMapClickCallback;

  /// onFloorsChangeCallback called when the available floors change
  final OnFloorsChangeCallback onFloorsChangeCallback;

  /// onFloorChangeCallback called when the current floor change
  final OnFloorChangeCallback onFloorChangeCallback;

  /// onVenueEnterCallback called when a venue is displayed
  final OnVenueEnterCallback onVenueEnterCallback;

  /// The Mapwize api key that will be used to retrieve data
  final String apiKey;

  /// If set, the map will be centered on this venue
  final String centerOnVenueId;

  /// If set, the map will be centered on this place
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
        onFloorChangeCallback: widget.onFloorChangeCallback,
        onVenueEnterCallback: widget.onVenueEnterCallback);
    _controller.complete(controller);
    if (widget.onMapCreatedCallback != null) {
      widget.onMapCreatedCallback(controller);
    }
  }
}
