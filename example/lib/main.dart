import 'package:Mapwize_example/FloorController.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mapwize/mapwize.dart';

import 'dart:typed_data';

void main() => runApp(MaterialApp(home: MapViewExample()));

class MapViewExample extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MapViewExempleState();
  }
}

class MapViewExempleState extends State<MapViewExample> {

  MapwizeMapController controller;
  List<Floor> _floors = List();
  Floor _floor = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Flutter Mapwize Example')),
        body: Column(children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                MapwizeMap(
                  apiKey: "MapwizeDevAPIKEY", //This is a demo API KEY that CANNOT be used for production.
                  centerOnVenueId: "56b20714c3fa800b00d8f0b5",
                  onMapCreatedCallback: _onMapViewCreated,
                  onMapLoadedCallback: _onMapLoaded,
                  onMapClickCallback: _onMapClick,
                  onFloorsChangeCallback: _onFloorsChanged,
                  onFloorChangeCallback: _onFloorChanged,
                  onVenueEnterCallback: _onVenueEnter,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: FloorControllerWidget(
                      floors: _floors,
                      floor: _floor,
                      onFloorTapCallback: _onFloorTapCallback,
                    ),
                  )
                )
              ],
            ),
          ),
          new FlatButton(
            onPressed: _addLineAndMarker,
            child: new Icon(Icons.add),
          ),
          new FlatButton(
            onPressed: _removeLineAndMarker,
            child: new Icon(Icons.delete),
          ),
        ]));
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  void _addLineAndMarker() async {
    controller.setFloor(3);
    SymbolOptions options = SymbolOptions(
        geometry: LatLng(10.0, 10.0),
        iconImage: "assetImage",
        iconSize: 3
    );
    Symbol s = await this.controller.addSymbol(options);
    LineOptions lineOptions = LineOptions(
        geometry: <LatLng>[LatLng(0.0, 0.0), LatLng(10.0, 10.0)],
        lineColor: "#C51586"
    );
    debugPrint("$lineOptions");
    this.controller.addLine(lineOptions);
  }

  void _removeLineAndMarker() async {
    this.controller.clearSymbols();
    this.controller.clearLines();
  }

  void _onMapViewCreated(MapwizeMapController controller) {
    debugPrint("On map view created");
    this.controller = controller;
  }

  void _onMapLoaded() {
    debugPrint("On map loaded");
    addImageFromAsset("assetImage", "assets/custom-icon.png");
  }

  void _onMapClick(LatLngFloor llf) {
    debugPrint("On map click $llf");
  }

  void _onFloorsChanged(List<Floor> floors) {
    debugPrint("On floors changed $floors");
    setState(() {
      _floors = floors;
      debugPrint("set state");
    });
  }

  void _onFloorChanged(Floor floor) {
    debugPrint("On floor changed $floor");
    setState(() {
      _floor = floor;
    });
  }

  void _onVenueEnter(Venue venue) {
    debugPrint("on venue enter ${venue.name}");
  }

  void _onFloorTapCallback(Floor floor) {
    controller.setFloor(floor.number);
  }

}