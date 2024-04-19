import 'dart:io';
import 'dart:typed_data';

abstract class HttpMessage {}

final class Request extends HttpMessage {
  final Map<String, String> parameters;
  final Map<String, String> query;
  final Uri uri;

  Request({required this.uri, required this.parameters, required this.query});
}

final class Response extends HttpMessage {
  final int statusCode;
  final ContentType contentType;
  final Uint8List? body;

  Response({this.statusCode = HttpStatus.ok, this.body, ContentType? contentType})
      : contentType = contentType ?? ContentType.text;
}
