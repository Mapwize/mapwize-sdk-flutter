package io.mapwize.sdk;

import com.mapbox.mapboxsdk.plugins.annotation.Symbol;

interface OnSymbolTappedListener {
    void onSymbolTapped(Symbol symbol);
}