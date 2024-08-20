import 'dart:collection';

import 'package:dext/src/constants.dart';
import 'package:dext/src/exception/immutable_exception.dart';

class DynamicMap<K, V> extends MapBase<K, V> {
  final Map<K, V> _inner;

  const DynamicMap(Map<K, V> map) : _inner = map;

  @override
  V? operator [](Object? key) => _inner[key];

  @override
  void operator []=(K key, V value) {
    if (kImmutableTypes) {
      throw const ImmutableException();
    }

    _inner[key] = value;
  }

  @override
  void clear() {
    if (kImmutableTypes) {
      throw const ImmutableException();
    }
    _inner.clear();
  }

  @override
  Iterable<K> get keys => _inner.keys;

  @override
  V? remove(Object? key) {
    if (kImmutableTypes) {
      throw const ImmutableException();
    }

    return _inner.remove(key);
  }
}
