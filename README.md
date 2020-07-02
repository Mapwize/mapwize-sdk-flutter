# Mapwize for Flutter

> **Please note that this project is community driven and is not an official Mapwize product.** We welcome [feedback](https://github.com/Mapwize/mapwize-sdk-flutter/issues) and contributions.

This Flutter plugin allows to show Mapwize indoor maps inside a Flutter widget. This project only supports a subset of the API exposed by the Mapwize native librairies.

## Running the example app

- Install [Flutter](https://flutter.io/get-started/) and validate its installation with `flutter doctor`
- Clone the repository with `git clone git@github.com:Mapwize/mapwize-sdk-flutter.git`
- Connect a mobile device or start an emulator, simulator or chrome
- Locate the id of a the device with `flutter devices`
- Run the app with `cd Mapwize/example && flutter packages get && flutter run -d {device_id}`

## Adding a Mapwize Api key

This project uses Mapwize data which requires a Mapwize account and a Mapwize api key. Obtain a Mapwize api key on [Mapwize Studio](https://studio.mapwize.io/).

To provide your api key, use the  `MapwizeMap` constructor's `apiKey` parameter.

## Using the SDK in your project

This project is available on [pub.dev](https://pub.dev/packages/mapwize_sdk). Follow the [instructions](https://flutter.dev/docs/development/packages-and-plugins/using-packages#adding-a-package-dependency-to-an-app) to integrate a package into your flutter application. For platform specific integration, use the flutter application under the example folder as reference.

## Map constructor parameters

The following parameters can be passed to the MapwizeMap constructor.

### `apiKey`

Must be provided to display the content;

### `centerOnPlaceId`

If set, center on the place at start.

### `centerOnVenueId`

If set, center on the venue at start.

### `void onMapCreatedCallback(MapwizeMapController controller)`

Called when the widget has been added to the application.

### `void onMapLoadedCallback()`

Called when the map is fully loaded and ready to use. Method calls before this are not guarented to work.

### `void onMapClickCallback(LatLngFloor latLngFloor)`

Called when the user clicks on the map.

### `void onFloorsChangeCallback:(List<Floor> floors)`

Called when the available floors have changed.

### `void onFloorChangeCallback(Floor floor)`,

Called when the displayed floor has changed.

### `void onVenueEnterCallback(Venue venue)`,

Called when the displayed floor has changed.

## Available methods

### `Future<void> setFloor(double floor)`

Set the currently displayed floor.

### `Future<void> addImage(String name, Uint8List bytes, [bool sdf = false])`

Add an image to the available images on the Mapbox map. Available images can be then used to display markers on the map.

### `Future<Symbol> addSymbol(SymbolOptions options, [Map data])`

Add a Symbol to the map using SymbolOptions. You can add custom properties using the data map.

### `Future<List<Symbol>> addSymbols(List<SymbolOptions> options, [List<Map> data])`

Add multples Symbol to the map using a List of SymbolOptions. You can add custom properties using the data map.

### `Future<LatLng> getSymbolLatLng(Symbol symbol)`

Retrieve the coordinates of a given Symbol.

### `Future<void> removeSymbol(Symbol symbol)`

Remove the given Symbol.

### `Future<void> removeSymbols(Iterable<Symbol> symbols)`

Remove all the given Symbols.

### `Future<void> clearSymbols()`

Remove all the Symbols.

### `Future<Line> addLine(LineOptions options, [Map data])`

Add a Line to the map using LymbolOptions. You can add custom properties using the data map.

### `Future<List<LatLng>> getLineLatLngs(Line line)`

Retrieve the coordinates of a given Line.

### `Future<void> removeLine(Line line)`

Remove the given Line.

### `Future<void> clearLines()`

Remove all the Lines.

## Contributing

We welcome contributions to this repository! If you're interested in helping build this Mapwize/Flutter integration, please read [the contribution guide](https://github.com/tobrun/mapwize-sdk-flutter/blob/master/CONTRIBUTING.md) to learn how to get started.
