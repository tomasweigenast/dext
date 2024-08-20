import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

final _emptyBuffer = Uint8List(0);

sealed class Body<T> {
  Stream<List<int>>? _stream;

  /// The total size of the body.
  ///
  /// If this is null, it is calculated when the response is build.
  final int? contentLength;

  /// The [ContentType] of the body.
  final ContentType? contentType;

  /// The encoding used to encode the body. Null if the body didn't apply any encoding.
  ///
  /// The encoding value should match the [contentType] charset. If not, this value takes precedence. If this
  /// is null, then [contentType] charset is used.
  final Encoding? encoding;

  Body(this._stream, this.contentLength, this.contentType, this.encoding);

  /// Reads the body to a buffer.
  ///
  /// This can be called once.
  Stream<List<int>> read() {
    assert(_stream != null, "Stream has already been read.");
    var stream = _stream;
    _stream = null;
    return stream!;
  }

  /// Creates a new, empty, [Body].
  factory Body.empty() => BytesContent<Never>(_emptyBuffer);
}

final class StringContent<T> extends Body<T> {
  StringContent._(super._stream, super.contentLength, super.contentType, super.encoding);

  factory StringContent(String content, {Encoding encoding = utf8, ContentType? contentType}) {
    contentType ??= ContentType.text;
    final buffer = encoding.encode(content);
    final stream = Stream<List<int>>.value(buffer);
    return StringContent._(stream, buffer.length, contentType, encoding);
  }

  /// A special constructor that encodes [value] as json and sets the content type to [ContentType.json] if [contentType] is not set.
  factory StringContent.json(T value, {Encoding encoding = utf8, ContentType? contentType}) {
    contentType ??= ContentType.json;
    final buffer = encoding.encode(jsonEncode(value));
    final stream = Stream<List<int>>.value(buffer);
    return StringContent._(stream, buffer.length, contentType, encoding);
  }
}

final class BytesContent<T> extends Body<T> {
  BytesContent._(super._stream, super.contentLength, super.contentType, super.encoding);

  factory BytesContent(Uint8List buffer, {ContentType? contentType}) {
    contentType ??= ContentType.binary;
    final stream = Stream<List<int>>.value(buffer);
    return BytesContent._(stream, buffer.length, contentType, null);
  }
}

final class StreamContent<T> extends Body<T> {
  StreamContent._(super.stream, super.contentLength, super.contentType, super.encoding);

  factory StreamContent(Stream<List<int>> stream, {ContentType? contentType}) {
    contentType ??= ContentType.binary;
    return StreamContent._(stream, null, contentType, null);
  }
}
