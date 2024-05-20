import 'dart:io';

import 'package:dext/src/body.dart';
import 'package:dext/src/headers.dart';
import 'package:dext/src/http_method.dart';

abstract class HttpMessage {
  /// The body
  final Body _body;

  final Headers _headers;

  int? get contentLength => _body.contentLength;

  ContentType get contentType => _body.contentType;

  Map<String, String> get headers => _headers.flatten;

  HttpMessage({Body? body, Map<String, List<String>>? headers})
      : _body = body ?? Body.empty(),
        _headers = Headers.from(headers);

  Stream<List<int>> read() => _body.read();
}

final class Request extends HttpMessage {
  final Map<String, String> parameters;
  final Map<String, String> query;
  final Uri uri;
  final HttpMethod method;

  Request({
    required this.uri,
    required this.parameters,
    required this.query,
    required this.method,
    super.body,
    super.headers,
  });

  Request copyWith({Map<String, String>? parameters, Map<String, String>? query}) => Request(
        parameters: parameters ?? this.parameters,
        query: query ?? this.query,
        method: method,
        uri: uri,
        body: _body,
        headers: _headers,
      );
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
