import 'dart:collection';

import 'package:dext/src/constants.dart';
import 'package:dext/src/dynamic_map.dart';
import 'package:http_parser/http_parser.dart';

final _emptyHeaders = Headers._empty();

final class Headers extends DynamicMap<String, List<String>> {
  Map<String, String>? _flatten;

  Map<String, String> get flatten {
    if (kImmutableTypes) {
      return _flatten ??= UnmodifiableMapView(CaseInsensitiveMap.from(map((key, value) => MapEntry(key, value.join(",")))));
    }

    return UnmodifiableMapView(CaseInsensitiveMap.from(map((key, value) => MapEntry(key, value.join(",")))));
  }

  Headers._empty() : super(kImmutableTypes ? const {} : {});

  Headers._(Map<String, List<String>> values)
      : super(CaseInsensitiveMap.from(Map.fromEntries(values.entries
            .where((element) => element.value.isNotEmpty)
            .map((e) => MapEntry(e.key, List.unmodifiable(e.value))))));

  factory Headers.empty() => kImmutableTypes ? _emptyHeaders : Headers._empty();
  factory Headers.from([Map<String, List<String>>? values]) {
    if (values == null || values.isEmpty) {
      return kImmutableTypes ? _emptyHeaders : Headers._empty();
    } else if (values is Headers) {
      return values;
    } else {
      return Headers._(values);
    }
  }
}
