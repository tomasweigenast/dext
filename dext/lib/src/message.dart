import 'dart:io';

import 'package:dext/src/body.dart';
import 'package:dext/src/headers.dart';

abstract class HttpMessage {
  /// The body
  final Body? _body;

  final Headers _headers;

  HttpMessage({Body? body, Map<String, List<String>>? headers})
      : _body = body,
        _headers = Headers.from(headers);

  Stream<List<int>>? read() => _body?.read();
}

final class Request extends HttpMessage {
  final Map<String, String> parameters;
  final Map<String, String> query;
  final Uri uri;

  Request({
    required this.uri,
    required this.parameters,
    required this.query,
    super.body,
  });
}

final class Response extends HttpMessage {
  final int statusCode;

  Response({
    this.statusCode = HttpStatus.ok,
    super.body,
  });

  Response.ok({Body? body}) : this(statusCode: HttpStatus.ok, body: body);
  Response.notFound({Body? body}) : this(statusCode: HttpStatus.notFound, body: body);
  Response.badRequest({Body? body}) : this(statusCode: HttpStatus.badRequest, body: body);
}
