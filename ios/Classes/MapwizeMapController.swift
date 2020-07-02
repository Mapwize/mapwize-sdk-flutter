import UIKit
import MapwizeSDK
import MapboxAnnotationExtension

class MapwizeMapController: NSObject, FlutterPlatformView, MGLAnnotationControllerDelegate {

    private var registrar: FlutterPluginRegistrar
    private var channel: FlutterMethodChannel?
    
    private var mapView: MWZMapView
    private var symbolAnnotationController: MGLSymbolAnnotationController?
    private var circleAnnotationController: MGLCircleAnnotationController?
    private var lineAnnotationController: MGLLineAnnotationController?
    
    func view() -> UIView {
        return mapView
    }
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, registrar: FlutterPluginRegistrar) {
        
        let opts = MWZOptions()
        var configuration:MWZMapwizeConfiguration?
        if let args = args as? [String: Any] {
            if let apiKey = args["apiKey"] as? String {
                configuration = MWZMapwizeConfiguration(apiKey: apiKey)
            }
            if let centerOnVenueId = args["centerOnVenueId"] as? String {
                opts.centerOnVenueId = centerOnVenueId
            }
            if let centerOnPlaceId = args["centerOnPlaceId"] as? String {
                opts.centerOnPlaceId = centerOnPlaceId
            }
        }
        if configuration == nil {
            mapView = MWZMapView(frame: frame, options: opts, mapwizeConfiguration: MWZMapwizeConfiguration.sharedInstance())
        }
        else {
            mapView = MWZMapView(frame: frame, options: opts, mapwizeConfiguration: configuration!)
        }
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.registrar = registrar
        
        super.init()
        
        channel = FlutterMethodChannel(name: "plugins.flutter.io/mapwize_sdk_\(viewId)", binaryMessenger: registrar.messenger())
        channel!.setMethodCallHandler(onMethodCall)
        
        mapView.delegate = self
        
        
    }
    
    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(methodCall.method) {
        case "symbols#addAll":
            guard let symbolAnnotationController = symbolAnnotationController else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }

            if let options = arguments["options"] as? [[String: Any]] {
                var symbols: [MGLSymbolStyleAnnotation] = [];
                for o in options {
                    if let symbol = getSymbolForOptions(options: o)  {
                        symbols.append(symbol)
                    }
                }
                if !symbols.isEmpty {
                    symbolAnnotationController.addStyleAnnotations(symbols)
                }

                result(symbols.map { $0.identifier })
            } else {
                result(nil)
            }
        case "symbols#removeAll":
            guard let symbolAnnotationController = symbolAnnotationController else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let symbolIds = arguments["symbols"] as? [String] else { return }
            var symbols: [MGLSymbolStyleAnnotation] = [];

            for symbol in symbolAnnotationController.styleAnnotations(){
                if symbolIds.contains(symbol.identifier) {
                    symbols.append(symbol as! MGLSymbolStyleAnnotation)
                }
            }
            symbolAnnotationController.removeStyleAnnotations(symbols)
            result(nil)
        case "line#add":
            guard let lineAnnotationController = lineAnnotationController else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            // Parse geometry
            if let options = arguments["options"] as? [String: Any],
                let geometry = options["geometry"] as? [[String:Double]] {
                // Convert geometry to coordinate and create a line.
                var lineCoordinates: [CLLocationCoordinate2D] = []
                for coordinate in geometry {
                    lineCoordinates.append(CLLocationCoordinate2DMake(coordinate["latitude"]!, coordinate["longitude"]!))
                }
                let line = MGLLineStyleAnnotation(coordinates: lineCoordinates, count: UInt(lineCoordinates.count))
                Convert.interpretLineOptions(options: arguments["options"], delegate: line)
                lineAnnotationController.addStyleAnnotation(line)
                result(line.identifier)
            } else {
                result(nil)
            }
        case "line#remove":
            guard let lineAnnotationController = lineAnnotationController else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let lineId = arguments["line"] as? String else { return }
            
            for line in lineAnnotationController.styleAnnotations() {
                if line.identifier == lineId {
                    lineAnnotationController.removeStyleAnnotation(line)
                    break;
                }
            }
            result(nil)
        case "style#addImage":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let name = arguments["name"] as? String else { return }
            guard let bytes = arguments["bytes"] as? FlutterStandardTypedData else { return }
            guard let sdf = arguments["sdf"] as? Bool else { return }
            guard let data = bytes.data as? Data else{ return }
            guard let image = UIImage(data: data) else { return }
            if (sdf) {
                self.mapView.mapboxMapView.style?.setImage(image.withRenderingMode(.alwaysTemplate), forName: name)
            } else {
                self.mapView.mapboxMapView.style?.setImage(image, forName: name)
            }
            result(nil)
        case "map#setFloor":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            mapView.setFloor(arguments["floorNumber"] as? NSNumber)
            result(nil)
        default:
            print("Not implemented")
        }
    }
        
    private func getSymbolForOptions(options: [String: Any]) -> MGLSymbolStyleAnnotation? {
        // Parse geometry
        if let geometry = options["geometry"] as? [String:Double] {
            // Convert geometry to coordinate and create symbol.
            let coordinate = CLLocationCoordinate2DMake(geometry["latitude"]!, geometry["longitude"]!)
            let symbol = MGLSymbolStyleAnnotation(coordinate: coordinate)
            Convert.interpretSymbolOptions(options: options, delegate: symbol)
            // Load icon image from asset if an icon name is supplied.
            if let iconImage = options["iconImage"] as? String {
                addIconImageToMap(iconImageName: iconImage)
            }
            return symbol
        }
        return nil
    }
    
    private func addIconImageToMap(iconImageName: String) {
        // Check if the image has already been added to the map.
        if self.mapView.mapboxMapView.style?.image(forName: iconImageName) == nil {
            // Build up the full path of the asset.
            // First find the last '/' ans split the image name in the asset directory and the image file name.
            if let range = iconImageName.range(of: "/", options: [.backwards]) {
                let directory = String(iconImageName[..<range.lowerBound])
                let assetPath = registrar.lookupKey(forAsset: "\(directory)/")
                let fileName = String(iconImageName[range.upperBound...])
                // If we can load the image from file then add it to the map.
                if let imageFromAsset = UIImage.loadFromFile(imagePath: assetPath, imageName: fileName) {
                    self.mapView.mapboxMapView.style?.setImage(imageFromAsset, forName: iconImageName)
                }
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false;
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
}

extension MapwizeMapController: MWZMapViewDelegate {
    
    func mapViewDidLoad(_ mapView: MWZMapView) {
        
        mapView.mapboxMapView.style?.setImage(UIImage(named: "pointer2")!, forName: "pointer2")
        
        lineAnnotationController = MGLLineAnnotationController(mapView: self.mapView.mapboxMapView)
        lineAnnotationController!.annotationsInteractionEnabled = false
        lineAnnotationController?.delegate = self

        symbolAnnotationController = MGLSymbolAnnotationController(mapView: self.mapView.mapboxMapView)
        symbolAnnotationController!.annotationsInteractionEnabled = false
        symbolAnnotationController?.delegate = self
        
        channel?.invokeMethod("map#onMapLoaded", arguments: nil)
    }
    
    func mapView(_ mapView: MWZMapView, didTap clickEvent: MWZClickEvent) {
        var arguments = [String:Any?]()
        arguments["latitude"] = clickEvent.latLngFloor.latitude()
        arguments["longitude"] = clickEvent.latLngFloor.longitude()
        arguments["floor"] = clickEvent.latLngFloor.floor
        channel?.invokeMethod("map#onMapClick", arguments: arguments)
        
        if (clickEvent.eventType == .venueClick) {
            mapView.centerOn(venuePreview: clickEvent.venuePreview!, animated: true)
        }
    }
    
    func mapView(_ mapView: MWZMapView, floorsDidChange floors: [MWZFloor]) {
        var arguments = [String:Any?]()
        var floorsArg = [[String:Any?]]()
        for floor in floors {
            floorsArg.append(["number":floor.number, "name": floor.name])
        }
        arguments["floors"] = floorsArg
        channel?.invokeMethod("map#onFloorsChanged", arguments: arguments)
    }
    
    func mapView(_ mapView: MWZMapView, floorDidChange floor: MWZFloor?) {
        if floor == nil {
            channel?.invokeMethod("map#onFloorChanged", arguments: nil)
        }
        else {
            let arguments = ["floor":["number":floor!.number, "name": floor!.name]] as [String : Any]
            channel?.invokeMethod("map#onFloorChanged", arguments: arguments)
        }
    }
    
    func mapView(_ mapView: MWZMapView, venueDidEnter venue: MWZVenue) {
        let arguments = ["venue":venue.toJSONString()] as [String : Any]
        channel?.invokeMethod("map#onVenueEnter", arguments: arguments)
    }
    
}
