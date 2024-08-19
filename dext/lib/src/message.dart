import 'dart:io';

import 'package:dext/dext.dart';
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
  final Context context;

  Request({
    required this.uri,
    required this.parameters,
    required this.query,
    required this.method,
    required this.context,
    super.body,
    super.headers,
  });

  Request copyWith({Map<String, String>? parameters, Map<String, String>? query}) => Request(
        parameters: parameters ?? this.parameters,
        query: query ?? this.query,
        method: method,
        context: context,
        uri: uri,
        body: _body,
        headers: _headers,
      );
}

final class Response extends HttpMessage {
  final int statusCode;

  Response({
    this.statusCode = HttpStatus.ok,
    super.headers,
    super.body,
  });

  Response.ok({Body? body}) : this(statusCode: HttpStatus.ok, body: body);
  Response.notFound({Body? body}) : this(statusCode: HttpStatus.notFound, body: body);
  Response.badRequest({Body? body}) : this(statusCode: HttpStatus.badRequest, body: body);

  Response copyWith({
    Body? body,
    int? statusCode,
    Map<String, String>? headers,
  }) =>
      Response(
        body: body ?? _body,
        statusCode: statusCode ?? this.statusCode,
      );
}
