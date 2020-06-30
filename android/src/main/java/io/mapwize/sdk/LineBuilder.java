package io.mapwize.sdk;

import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.plugins.annotation.Line;
import com.mapbox.mapboxsdk.plugins.annotation.LineManager;
import com.mapbox.mapboxsdk.plugins.annotation.LineOptions;

import java.util.List;

class LineBuilder implements LineOptionsSink {
    private final LineManager lineManager;
    private final LineOptions lineOptions;

    LineBuilder(LineManager lineManager) {
        this.lineManager = lineManager;
        this.lineOptions = new LineOptions();
    }

    Line build() {
        return lineManager.create(lineOptions);
    }

    @Override
    public void setLineJoin(String lineJoin) {
        lineOptions.withLineJoin(lineJoin);
    }

    @Override
    public void setLineOpacity(float lineOpacity) {
        lineOptions.withLineOpacity(lineOpacity);
    }

    @Override
    public void setLineColor(String lineColor) {
        lineOptions.withLineColor(lineColor);
    }

    @Override
    public void setLineWidth(float lineWidth) {
        lineOptions.withLineWidth(lineWidth);
    }

    @Override
    public void setLineGapWidth(float lineGapWidth) {
        lineOptions.withLineGapWidth(lineGapWidth);
    }

    @Override
    public void setLineOffset(float lineOffset) {
        lineOptions.withLineOffset(lineOffset);
    }

    @Override
    public void setLineBlur(float lineBlur) {
        lineOptions.withLineBlur(lineBlur);
    }

    @Override
    public void setLinePattern(String linePattern) {
        lineOptions.withLinePattern(linePattern);
    }

    @Override
    public void setGeometry(List<LatLng> geometry) {
        lineOptions.withLatLngs(geometry);
    }

    @Override
    public void setDraggable(boolean draggable) {
        lineOptions.withDraggable(draggable);
    }
}