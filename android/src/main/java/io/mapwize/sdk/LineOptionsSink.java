package io.mapwize.sdk;

import java.util.List;
import com.mapbox.mapboxsdk.geometry.LatLng;

/**
 * Receiver of Line configuration options.
 */
interface LineOptionsSink {

    void setLineJoin(String lineJoin);

    void setLineOpacity(float lineOpacity);

    void setLineColor(String lineColor);

    void setLineWidth(float lineWidth);

    void setLineGapWidth(float lineGapWidth);

    void setLineOffset(float lineOffset);

    void setLineBlur(float lineBlur);

    void setLinePattern(String linePattern);

    void setGeometry(List<LatLng> geometry);

    void setDraggable(boolean draggable);
}