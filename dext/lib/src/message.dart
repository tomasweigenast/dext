import 'dart:io';

import 'package:dext/dext.dart';
import 'package:dext/src/body.dart';
import 'package:dext/src/headers.dart';
import 'package:dext/src/http_method.dart';

abstract class HttpMessage<T> {
  /// The body
  final Body<T> _body;

  final Headers _headers;

  int? get contentLength => _body.contentLength;

  ContentType get contentType => _body.contentType;

  Map<String, String> get headers => _headers.flatten;

  HttpMessage({Body<T>? body, Map<String, List<String>>? headers})
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

final class Response<T> extends HttpMessage<T> {
  final int statusCode;

  Response({
    this.statusCode = HttpStatus.ok,
    super.headers,
    super.body,
  });

  Response.okd(T data) : this.ok(body: StringContent.json(data));
  Response.ok({Body<T>? body}) : this(statusCode: HttpStatus.ok, body: body);
  Response.notFound({Body<T>? body}) : this(statusCode: HttpStatus.notFound, body: body);
  Response.badRequest({Body<T>? body}) : this(statusCode: HttpStatus.badRequest, body: body);

  Response copyWith({
    Body<T>? body,
    int? statusCode,
    Map<String, String>? headers,
  }) =>
      Response(
        body: body ?? _body,
        statusCode: statusCode ?? this.statusCode,
        // headers: , // TODO: add copy of headers
      );
}
