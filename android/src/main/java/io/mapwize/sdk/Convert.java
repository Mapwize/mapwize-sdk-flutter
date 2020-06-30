package io.mapwize.sdk;

import android.graphics.Point;

import com.mapbox.mapboxsdk.camera.CameraPosition;
import com.mapbox.mapboxsdk.camera.CameraUpdate;
import com.mapbox.mapboxsdk.camera.CameraUpdateFactory;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.geometry.LatLngBounds;
import com.mapbox.mapboxsdk.log.Logger;
import com.mapbox.mapboxsdk.maps.MapboxMap;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Conversions between JSON-like values and MapboxMaps data types.
 */
class Convert {

    private final static String TAG = "Convert";

    private static boolean toBoolean(Object o) {
        return (Boolean) o;
    }

    static CameraPosition toCameraPosition(Object o) {
        final Map<?, ?> data = toMap(o);
        final CameraPosition.Builder builder = new CameraPosition.Builder();
        builder.bearing(toFloat(data.get("bearing")));
        builder.target(toLatLng(data.get("target")));
        builder.tilt(toFloat(data.get("tilt")));
        builder.zoom(toFloat(data.get("zoom")));
        return builder.build();
    }

    static boolean isScrollByCameraUpdate(Object o) {
        return toString(toList(o).get(0)).equals("scrollBy");
    }

    static CameraUpdate toCameraUpdate(Object o, MapboxMap mapboxMap, float density) {
        final List<?> data = toList(o);
        switch (toString(data.get(0))) {
            case "newCameraPosition":
                return CameraUpdateFactory.newCameraPosition(toCameraPosition(data.get(1)));
            case "newLatLng":
                return CameraUpdateFactory.newLatLng(toLatLng(data.get(1)));
            case "newLatLngBounds":
                return CameraUpdateFactory.newLatLngBounds(
                        toLatLngBounds(data.get(1)), toPixels(data.get(2), density));
            case "newLatLngZoom":
                return CameraUpdateFactory.newLatLngZoom(toLatLng(data.get(1)), toFloat(data.get(2)));
            case "scrollBy":
                mapboxMap.scrollBy(
                        toFractionalPixels(data.get(1), density),
                        toFractionalPixels(data.get(2), density)
                );
                return null;
            case "zoomBy":
                if (data.size() == 2) {
                    return CameraUpdateFactory.zoomBy(toFloat(data.get(1)));
                } else {
                    return CameraUpdateFactory.zoomBy(toFloat(data.get(1)), toPoint(data.get(2), density));
                }
            case "zoomIn":
                return CameraUpdateFactory.zoomIn();
            case "zoomOut":
                return CameraUpdateFactory.zoomOut();
            case "zoomTo":
                return CameraUpdateFactory.zoomTo(toFloat(data.get(1)));
            case "bearingTo":
                return CameraUpdateFactory.bearingTo(toFloat(data.get(1)));
            case "tiltTo":
                return CameraUpdateFactory.tiltTo(toFloat(data.get(1)));
            default:
                throw new IllegalArgumentException("Cannot interpret " + o + " as CameraUpdate");
        }
    }

    private static double toDouble(Object o) {
        return ((Number) o).doubleValue();
    }

    private static float toFloat(Object o) {
        return ((Number) o).floatValue();
    }

    private static Float toFloatWrapper(Object o) {
        return (o == null) ? null : toFloat(o);
    }

    static int toInt(Object o) {
        return ((Number) o).intValue();
    }

    static Object toJson(CameraPosition position) {
        if (position == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>();
        data.put("bearing", position.bearing);
        data.put("target", toJson(position.target));
        data.put("tilt", position.tilt);
        data.put("zoom", position.zoom);
        return data;
    }

    private static Object toJson(LatLng latLng) {
        return Arrays.asList(latLng.getLatitude(), latLng.getLongitude());
    }

    private static LatLng toLatLng(Object o) {
        final Map<?, ?> data = toMap(o);
        return new LatLng(toDouble(data.get("latitude")), toDouble(data.get("longitude")));
    }

    private static LatLngBounds toLatLngBounds(Object o) {
        if (o == null) {
            return null;
        }
        final List<?> data = toList(o);
        LatLng[] boundsArray = new LatLng[] {toLatLng(data.get(0)), toLatLng(data.get(1))};
        List<LatLng> bounds = Arrays.asList(boundsArray);
        LatLngBounds.Builder builder = new LatLngBounds.Builder();
        builder.includes(bounds);
        return builder.build();
    }

    private static List<LatLng> toLatLngList(Object o) {
        if (o == null) {
            return null;
        }
        final List<?> data = toList(o);
        List<LatLng> latLngList = new ArrayList<>();
        for (int i=0; i<data.size(); i++) {
            final Map<?, ?> coords = toMap(data.get(i));
            latLngList.add(new LatLng(toDouble(coords.get("latitude")), toDouble(coords.get("longitude"))));
        }
        return latLngList;
    }

    private static List<?> toList(Object o) {
        return (List<?>) o;
    }

    static long toLong(Object o) {
        return ((Number) o).longValue();
    }

    static Map<?, ?> toMap(Object o) {
        return (Map<?, ?>) o;
    }

    private static float toFractionalPixels(Object o, float density) {
        return toFloat(o) * density;
    }

    static int toPixels(Object o, float density) {
        return (int) toFractionalPixels(o, density);
    }

    private static Point toPoint(Object o, float density) {
        final List<?> data = toList(o);
        return new Point(toPixels(data.get(0), density), toPixels(data.get(1), density));
    }

    private static String toString(Object o) {
        return (String) o;
    }

    static void interpretSymbolOptions(Object o, SymbolOptionsSink sink) {
        final Map<?, ?> data = toMap(o);
        final Object iconSize = data.get("iconSize");
        if (iconSize != null) {
            sink.setIconSize(toFloat(iconSize));
        }
        final Object iconImage = data.get("iconImage");
        if (iconImage != null) {
            sink.setIconImage(toString(iconImage));
        }
        final Object iconRotate = data.get("iconRotate");
        if (iconRotate != null) {
            sink.setIconRotate(toFloat(iconRotate));
        }
        final Object iconOffset = data.get("iconOffset");
        if (iconOffset != null) {
            sink.setIconOffset(new float[] {toFloat(toList(iconOffset).get(0)), toFloat(toList(iconOffset).get(1))});
        }
        final Object iconAnchor = data.get("iconAnchor");
        if (iconAnchor != null) {
            sink.setIconAnchor(toString(iconAnchor));
        }
        final Object textField = data.get("textField");
        if (textField != null) {
            sink.setTextField(toString(textField));
        }
        final Object textSize = data.get("textSize");
        if (textSize != null) {
            sink.setTextSize(toFloat(textSize));
        }
        final Object textMaxWidth = data.get("textMaxWidth");
        if (textMaxWidth != null) {
            sink.setTextMaxWidth(toFloat(textMaxWidth));
        }
        final Object textLetterSpacing = data.get("textLetterSpacing");
        if (textLetterSpacing != null) {
            sink.setTextLetterSpacing(toFloat(textLetterSpacing));
        }
        final Object textJustify = data.get("textJustify");
        if (textJustify != null) {
            sink.setTextJustify(toString(textJustify));
        }
        final Object textAnchor = data.get("textAnchor");
        if (textAnchor != null) {
            sink.setTextAnchor(toString(textAnchor));
        }
        final Object textRotate = data.get("textRotate");
        if (textRotate != null) {
            sink.setTextRotate(toFloat(textRotate));
        }
        final Object textTransform = data.get("textTransform");
        if (textTransform != null) {
            sink.setTextTransform(toString(textTransform));
        }
        final Object textOffset = data.get("textOffset");
        if (textOffset != null) {
            sink.setTextOffset(new float[] {toFloat(toList(textOffset).get(0)), toFloat(toList(textOffset).get(1))});
        }
        final Object iconOpacity = data.get("iconOpacity");
        if (iconOpacity != null) {
            sink.setIconOpacity(toFloat(iconOpacity));
        }
        final Object iconColor = data.get("iconColor");
        if (iconColor != null) {
            sink.setIconColor(toString(iconColor));
        }
        final Object iconHaloColor = data.get("iconHaloColor");
        if (iconHaloColor != null) {
            sink.setIconHaloColor(toString(iconHaloColor));
        }
        final Object iconHaloWidth = data.get("iconHaloWidth");
        if (iconHaloWidth != null) {
            sink.setIconHaloWidth(toFloat(iconHaloWidth));
        }
        final Object iconHaloBlur = data.get("iconHaloBlur");
        if (iconHaloBlur != null) {
            sink.setIconHaloBlur(toFloat(iconHaloBlur));
        }
        final Object textOpacity = data.get("textOpacity");
        if (textOpacity != null) {
            sink.setTextOpacity(toFloat(textOpacity));
        }
        final Object textColor = data.get("textColor");
        if (textColor != null) {
            sink.setTextColor(toString(textColor));
        }
        final Object textHaloColor = data.get("textHaloColor");
        if (textHaloColor != null) {
            sink.setTextHaloColor(toString(textHaloColor));
        }
        final Object textHaloWidth = data.get("textHaloWidth");
        if (textHaloWidth != null) {
            sink.setTextHaloWidth(toFloat(textHaloWidth));
        }
        final Object textHaloBlur = data.get("textHaloBlur");
        if (textHaloBlur != null) {
            sink.setTextHaloBlur(toFloat(textHaloBlur));
        }
        final Object geometry = data.get("geometry");
        if (geometry != null) {
            sink.setGeometry(toLatLng(geometry));
        }
        final Object symbolSortKey = data.get("zIndex");
        if (symbolSortKey != null) {
            sink.setSymbolSortKey(toFloat(symbolSortKey));
        }
        final Object draggable = data.get("draggable");
        if (draggable != null) {
            sink.setDraggable(toBoolean(draggable));
        }
    }

    static void interpretLineOptions(Object o, LineOptionsSink sink) {
        final Map<?, ?> data = toMap(o);
        final Object lineJoin = data.get("lineJoin");
        if (lineJoin != null) {
            Logger.e(TAG, "setLineJoin" +  lineJoin);
            sink.setLineJoin(toString(lineJoin));
        }
        final Object lineOpacity = data.get("lineOpacity");
        if (lineOpacity != null) {
            Logger.e(TAG, "setLineOpacity" + lineOpacity);
            sink.setLineOpacity(toFloat(lineOpacity));
        }
        final Object lineColor = data.get("lineColor");
        if (lineColor != null) {
            Logger.e(TAG, "setLineColor" +  lineColor);
            sink.setLineColor(toString(lineColor));
        }
        final Object lineWidth = data.get("lineWidth");
        if (lineWidth != null) {
            Logger.e(TAG, "setLineWidth" + lineWidth);
            sink.setLineWidth(toFloat(lineWidth));
        }
        final Object lineGapWidth = data.get("lineGapWidth");
        if (lineGapWidth != null) {
            Logger.e(TAG, "setLineGapWidth" + lineGapWidth);
            sink.setLineGapWidth(toFloat(lineGapWidth));
        }
        final Object lineOffset = data.get("lineOffset");
        if (lineOffset != null) {
            Logger.e(TAG, "setLineOffset" + lineOffset);
            sink.setLineOffset(toFloat(lineOffset));
        }
        final Object lineBlur = data.get("lineBlur");
        if (lineBlur != null) {
            Logger.e(TAG, "setLineBlur" + lineBlur);
            sink.setLineBlur(toFloat(lineBlur));
        }
        final Object linePattern = data.get("linePattern");
        if (linePattern != null) {
            Logger.e(TAG, "setLinePattern" +  linePattern);
            sink.setLinePattern(toString(linePattern));
        }
        final Object geometry = data.get("geometry");
        if (geometry != null) {
            Logger.e(TAG, "SetGeometry");
            sink.setGeometry(toLatLngList(geometry));
        }
        final Object draggable = data.get("draggable");
        if (draggable != null) {
            Logger.e(TAG, "SetDraggable");
            sink.setDraggable(toBoolean(draggable));
        }
    }
}