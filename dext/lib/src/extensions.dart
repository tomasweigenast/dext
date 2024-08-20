import 'dart:io';

extension HeadersExt on Map<String, List<String>> {
  ContentType? getContentType() {
    final rawValue = this[HttpHeaders.contentTypeHeader]?.firstOrNull;
    if (rawValue == null) return null;
    return ContentType.parse(rawValue);
  }
}
