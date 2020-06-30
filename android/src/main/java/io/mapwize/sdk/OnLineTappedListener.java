package io.mapwize.sdk;

import com.mapbox.mapboxsdk.plugins.annotation.Line;

interface OnLineTappedListener {
    void onLineTapped(Line line);
}