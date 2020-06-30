package io.mapwize.sdk;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

/** MapwizeMapPlugin */
public class MapwizePlugin implements FlutterPlugin {

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    flutterPluginBinding
            .getPlatformViewRegistry()
            .registerViewFactory( "plugins.flutter.io/mapwize_sdk", new MapwizeViewFactory(flutterPluginBinding.getBinaryMessenger()));
    MethodChannel methodChannel =
            new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugins.flutter.io/mapwize_sdk");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

  }

}