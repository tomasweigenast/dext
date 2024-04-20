import 'dart:collection';

import 'package:http_parser/http_parser.dart';

final _emptyHeaders = Headers._empty();

final class Headers extends UnmodifiableMapView<String, List<String>> {
  late final Map<String, String> flatten =
      UnmodifiableMapView(CaseInsensitiveMap.from(map((key, value) => MapEntry(key, value.join(",")))));

  Headers._empty() : super(const {});

  Headers._(Map<String, List<String>> values)
      : super(CaseInsensitiveMap.from(Map.fromEntries(values.entries
            .where((element) => element.value.isNotEmpty)
            .map((e) => MapEntry(e.key, List.unmodifiable(e.value))))));

  factory Headers.empty() => _emptyHeaders;
  factory Headers.from([Map<String, List<String>>? values]) {
    if (values == null || values.isEmpty) {
      return _emptyHeaders;
    } else if (values is Headers) {
      return values;
    } else {
      return Headers._(values);
    }
  }
}
