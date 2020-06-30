import Flutter
import UIKit
import MapwizeSDK

public class SwiftMapwizePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = MapwizeMapFactory(withRegistrar: registrar)
    registrar.register(instance, withId: "plugins.flutter.io/mapwize_sdk")
  }
}
