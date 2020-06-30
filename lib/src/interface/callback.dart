part of mapwize_sdk;

/**
 * https://github.com/tobrun/flutter-mapbox-gl/blob/master
 */

typedef void ArgumentCallback<T>(T argument);

class ArgumentCallbacks<T> {
  final List<ArgumentCallback<T>> _callbacks = <ArgumentCallback<T>>[];

  void call(T argument) {
    final int length = _callbacks.length;
    if (length == 1) {
      _callbacks[0].call(argument);
    } else if (0 < length) {
      for (ArgumentCallback<T> callback
      in List<ArgumentCallback<T>>.from(_callbacks)) {
        callback(argument);
      }
    }
  }

  void add(ArgumentCallback<T> callback) {
    assert(callback != null);
    _callbacks.add(callback);
  }

  void remove(ArgumentCallback<T> callback) {
    _callbacks.remove(callback);
  }

  bool get isEmpty => _callbacks.isEmpty;

  bool get isNotEmpty => _callbacks.isNotEmpty;
}