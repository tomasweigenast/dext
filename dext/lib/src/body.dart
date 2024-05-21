import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

final _emptyBuffer = Uint8List(0);

sealed class Body {
  Stream<List<int>>? _stream;

  /// The total size of the body.
  ///
  /// If this is null, it is calculated when the response is build.
  final int? contentLength;

  /// The [ContentType] of the response.
  final ContentType contentType;

  Body(this._stream, this.contentLength, this.contentType);

  /// Reads the body to a buffer.
  ///
  /// This can be called once.
  Stream<List<int>> read() {
    assert(_stream != null, "Stream has already been read.");
    var stream = _stream;
    _stream = null;
    return stream!;
  }

  factory Body.empty() => BytesContent(_emptyBuffer);
}

final class StringContent extends Body {
  StringContent._(super._stream, super.contentLength, super.contentType);

  factory StringContent(String content, {Encoding encoding = utf8, ContentType? contentType}) {
    contentType ??= ContentType.text;
    final buffer = encoding.encode(content);
    final stream = Stream<List<int>>.value(buffer);
    return StringContent._(stream, buffer.length, contentType);
  }

  /// A special constructor that encodes [value] as json and sets the content type to [ContentType.json] if [contentType] is not set.
  factory StringContent.json(dynamic value, {Encoding encoding = utf8, ContentType? contentType}) {
    contentType ??= ContentType.json;
    final buffer = encoding.encode(jsonEncode(value));
    final stream = Stream<List<int>>.value(buffer);
    return StringContent._(stream, buffer.length, contentType);
  }
}

final class BytesContent extends Body {
  BytesContent._(super._stream, super.contentLength, super.contentType);

  factory BytesContent(Uint8List buffer, {ContentType? contentType}) {
    contentType ??= ContentType.binary;
    final stream = Stream<List<int>>.value(buffer);
    return BytesContent._(stream, buffer.length, contentType);
  }
}

final class StreamContent extends Body {
  StreamContent._(super.stream, super.contentLength, super.contentType);

  factory StreamContent(Stream<List<int>> stream, {ContentType? contentType}) {
    contentType ??= ContentType.binary;
    return StreamContent._(stream, null, contentType);
  }
}
