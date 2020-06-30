package io.mapwize.sdk;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.mapbox.mapboxsdk.Mapbox;
import com.mapbox.mapboxsdk.maps.Style;
import com.mapbox.mapboxsdk.plugins.annotation.Annotation;
import com.mapbox.mapboxsdk.plugins.annotation.Line;
import com.mapbox.mapboxsdk.plugins.annotation.LineManager;
import com.mapbox.mapboxsdk.plugins.annotation.OnAnnotationClickListener;
import com.mapbox.mapboxsdk.plugins.annotation.Symbol;
import com.mapbox.mapboxsdk.plugins.annotation.SymbolManager;
import com.mapbox.mapboxsdk.plugins.annotation.SymbolOptions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;
import io.mapwize.mapwizesdk.api.Floor;
import io.mapwize.mapwizesdk.core.MapwizeConfiguration;
import io.mapwize.mapwizesdk.map.ClickEvent;
import io.mapwize.mapwizesdk.map.MapOptions;
import io.mapwize.mapwizesdk.map.MapwizeMap;
import io.mapwize.mapwizesdk.map.MapwizeView;

public class MapwizeMapController
        implements Application.ActivityLifecycleCallbacks,
        PlatformView,
        MethodCallHandler,
        OnSymbolTappedListener,
        OnLineTappedListener,
        OnAnnotationClickListener {

    private boolean disposed = false;
    private final MethodChannel methodChannel;
    private MapwizeView mapwizeView;
    private MapwizeMap mapwizeMap;
    private SymbolManager symbolManager;
    private LineManager lineManager;
    private final Map<String, SymbolController> symbols;
    private final Map<String, LineController> lines;

    MapwizeMapController(Context context,
                         BinaryMessenger messenger, int id, String apikey, MapOptions opts) {

        ((Application)context.getApplicationContext()).registerActivityLifecycleCallbacks(this);

        methodChannel = new MethodChannel(messenger, "plugins.flutter.io/mapwize_sdk_" + id);
        methodChannel.setMethodCallHandler(this);

        this.symbols = new HashMap<>();
        this.lines = new HashMap<>();

        Mapbox.getInstance(context, "pk.mapwize");
        MapwizeConfiguration.start(new MapwizeConfiguration.Builder(context, apikey).build());
        mapwizeView = new MapwizeView(context, opts);
        mapwizeView.getMapAsync(new MapwizeView.OnMapwizeReadyCallback() {
            @Override
            public void onMapwizeReady(MapwizeMap mapwizeMap) {
                MapwizeMapController.this.mapwizeMap = mapwizeMap;
                methodChannel.invokeMethod("map#onMapLoaded", null);
                enableLineManager(mapwizeMap.getMapboxMap().getStyle());
                enableSymbolManager(mapwizeMap.getMapboxMap().getStyle());
                mapwizeMap.addOnFloorsChangeListener(new MapwizeMap.OnFloorsChangeListener() {
                    @Override
                    public void onFloorsChange(@NonNull List<Floor> floors) {
                        final Map<String, Object> arguments = new HashMap<>(1);
                        List<Map<String, Object>> list = new ArrayList();
                        for (Floor floor : floors) {
                            Map<String, Object> f = new HashMap<>(2);
                            f.put("number", floor.getNumber());
                            f.put("name", floor.getName());
                            list.add(f);
                        }
                        arguments.put("floors", list);
                        methodChannel.invokeMethod("map#onFloorsChanged", arguments);
                    }
                });

                mapwizeMap.addOnFloorChangeListener(new MapwizeMap.OnFloorChangeListener() {
                    @Override
                    public void onFloorWillChange(@Nullable Floor floor) {

                    }

                    @Override
                    public void onFloorChange(@Nullable Floor floor) {
                        if (floor == null) {
                            methodChannel.invokeMethod("map#onFloorChanged", null);
                        }
                        else {
                            final Map<String, Object> arguments = new HashMap<>(1);
                            Map<String, Object> f = new HashMap<>(2);
                            f.put("number", floor.getNumber());
                            f.put("name", floor.getName());
                            arguments.put("floor", f);
                            methodChannel.invokeMethod("map#onFloorChanged", arguments);
                        }
                    }

                    @Override
                    public void onFloorChangeError(@Nullable Floor floor, @NonNull Throwable throwable) {

                    }
                });

                mapwizeMap.addOnClickListener(new MapwizeMap.OnClickListener() {
                    @Override
                    public void onClickEvent(@NonNull ClickEvent clickEvent) {
                        Log.i("Debug", "On Map click");
                        final Map<String, Object> arguments = new HashMap<>(5);
                        arguments.put("latitude", clickEvent.getLatLngFloor().getLatitude());
                        arguments.put("longitude", clickEvent.getLatLngFloor().getLongitude());
                        arguments.put("floor", clickEvent.getLatLngFloor().getFloor());
                        methodChannel.invokeMethod("map#onMapClick", arguments);
                    }
                });
            }
        });

        mapwizeView.onCreate(null);
        mapwizeView.onStart();
        mapwizeView.onResume();

    }

    @Override
    public View getView() {
        return mapwizeView;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "symbols#addAll": {
                List<String> newSymbolIds = new ArrayList<String>();
                final List<Object> options = methodCall.argument("options");
                List<SymbolOptions> symbolOptionsList = new ArrayList<>();
                if (options != null) {
                    SymbolBuilder symbolBuilder;
                    for (Object o : options) {
                        symbolBuilder =  new SymbolBuilder();
                        Convert.interpretSymbolOptions(o, symbolBuilder);
                        symbolOptionsList.add(symbolBuilder.getSymbolOptions());
                    }
                    if (!symbolOptionsList.isEmpty()) {
                        List<Symbol> newSymbols = symbolManager.create(symbolOptionsList);
                        String symbolId;
                        for (Symbol symbol : newSymbols) {
                            symbolId = String.valueOf(symbol.getId());
                            newSymbolIds.add(symbolId);
                            symbols.put(symbolId, new SymbolController(symbol, true, this));
                        }
                    }
                }
                result.success(newSymbolIds);
                break;
            }
            case "symbols#removeAll": {
                final ArrayList<String> symbolIds = methodCall.argument("symbols");
                SymbolController symbolController;

                List<Symbol> symbolList = new ArrayList<>();
                for(String symbolId : symbolIds){
                    symbolController = symbols.remove(symbolId);
                    if (symbolController != null) {
                        symbolList.add(symbolController.getSymbol());
                    }
                }
                if(!symbolList.isEmpty()) {
                    symbolManager.delete(symbolList);
                }
                result.success(null);
                break;
            }
            case "line#add": {
                final LineBuilder lineBuilder = new LineBuilder(lineManager);
                Convert.interpretLineOptions(methodCall.argument("options"), lineBuilder);
                final Line line = lineBuilder.build();
                final String lineId = String.valueOf(line.getId());
                lines.put(lineId, new LineController(line, true, this));
                result.success(lineId);
                break;
            }
            case "line#remove": {
                final String lineId = methodCall.argument("line");
                removeLine(lineId);
                result.success(null);
                break;
            }
            case "style#addImage":{
                if(mapwizeMap.getMapboxMap().getStyle()==null){
                    result.error("STYLE IS NULL", "The style is null. Has onStyleLoaded() already been invoked?", null);
                }
                mapwizeMap.getMapboxMap().getStyle().addImage(methodCall.argument("name"), BitmapFactory.decodeByteArray(methodCall.argument("bytes"),0,methodCall.argument("length")), methodCall.argument("sdf"));
                result.success(null);
                break;
            }
            default:
                result.notImplemented();
        }
    }

    private void enableSymbolManager(@NonNull Style style) {
        if (symbolManager == null) {
            symbolManager = new SymbolManager(mapwizeMap.getMapboxMapView(), mapwizeMap.getMapboxMap(), style);
            symbolManager.setIconAllowOverlap(true);
            symbolManager.setIconIgnorePlacement(true);
            symbolManager.setTextAllowOverlap(true);
            symbolManager.setTextIgnorePlacement(true);
            symbolManager.addClickListener(MapwizeMapController.this::onAnnotationClick);
        }
    }

    private void enableLineManager(@NonNull Style style) {
        if (lineManager == null) {
            lineManager = new LineManager(mapwizeMap.getMapboxMapView(), mapwizeMap.getMapboxMap(), style);
            lineManager.addClickListener(MapwizeMapController.this::onAnnotationClick);
        }
    }

    private void removeLine(String lineId) {
        final LineController lineController = lines.remove(lineId);
        if (lineController != null) {
            lineController.remove(lineManager);
        }
    }

    @Override
    public void onAnnotationClick(Annotation annotation) {
        if (annotation instanceof Symbol) {
            final SymbolController symbolController = symbols.get(String.valueOf(annotation.getId()));
            if (symbolController != null) {
                symbolController.onTap();
            }
        }

        if (annotation instanceof Line) {
            final LineController lineController = lines.get(String.valueOf(annotation.getId()));
            if (lineController != null) {
                lineController.onTap();
            }
        }
    }

    @Override
    public void onSymbolTapped(Symbol symbol) {
        final Map<String, Object> arguments = new HashMap<>(2);
        arguments.put("symbol", String.valueOf(symbol.getId()));
        methodChannel.invokeMethod("symbol#onTap", arguments);
    }

    @Override
    public void onLineTapped(Line line) {
        final Map<String, Object> arguments = new HashMap<>(2);
        arguments.put("line", String.valueOf(line.getId()));
        methodChannel.invokeMethod("line#onTap", arguments);
    }


    @Override
    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        if (symbolManager != null) {
            symbolManager.onDestroy();
        }
        if (lineManager != null) {
            lineManager.onDestroy();
        }


        mapwizeView.onDestroy();
        ((Application)getView().getContext().getApplicationContext()).registerActivityLifecycleCallbacks(this);
    }

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
        Log.i("Debug", "onActivityCreated");
        mapwizeView.onCreate(savedInstanceState);
    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {
        Log.i("Debug", "onActivityStarted");
        mapwizeView.onStart();
    }

    @Override
    public void onActivityResumed(@NonNull Activity activity) {
        Log.i("Debug", "onActivityResumed");
        mapwizeView.onResume();
    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {
        Log.i("Debug", "onActivityPaused");
        mapwizeView.onPause();
    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {
        Log.i("Debug", "onActivityStopped");
        mapwizeView.onStop();
    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
        Log.i("Debug", "onActivitySaveInstanceState");
        mapwizeView.onSaveInstanceState(outState);
    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {
        Log.i("Debug", "onActivityDestroyed");
        mapwizeView.onDestroy();
    }
}