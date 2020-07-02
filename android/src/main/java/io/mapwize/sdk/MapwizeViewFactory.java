package io.mapwize.sdk;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.mapwize.mapwizesdk.map.MapOptions;

public class MapwizeViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;

    public MapwizeViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        MapOptions.Builder optionsBuilder = new MapOptions.Builder();
        if (params.containsKey("centerOnPlaceId") && params.get("centerOnPlaceId") != null) {
            optionsBuilder.centerOnPlace((String)params.get("centerOnPlaceId"));
        }
        if (params.containsKey("centerOnVenueId") && params.get("centerOnVenueId") != null) {
            optionsBuilder.centerOnVenue((String)params.get("centerOnVenueId"));
        }

        return new MapwizeMapController(context, messenger, id, (String)params.get("apiKey"), optionsBuilder.build());
    }
}
