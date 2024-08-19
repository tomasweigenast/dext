import 'dart:convert';
import 'dart:io';

import 'package:dext/dext.dart';
import 'package:dext/src/body.dart';
import 'package:dext/src/headers.dart';
import 'package:dext/src/http_method.dart';

abstract class HttpMessage<T> {
  final Body<T> _body;
  final Headers _headers;

  Encoding? get encoding {
    var contentType = _body.contentType;
    if (contentType == null) return null;
    if (!contentType.parameters.containsKey('charset')) return null;
    return Encoding.getByName(contentType.parameters['charset']);
  }

  int? get contentLength => _body.contentLength;

  ContentType? get contentType => _body.contentType;

  Headers get headers => _headers;

  HttpMessage({Body<T>? body, Map<String, List<String>> headers = const {}})
      : _body = body ?? Body.empty(),
        _headers = Headers.from(headers);

  Stream<List<int>> read() => _body.read();

  Future<String> readAsString([Encoding? encoding]) async {
    encoding ??= this.encoding ?? utf8;
    return encoding.decodeStream(read());
  }
}

final class Request<T> extends HttpMessage<T> {
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

  Request<T> copyWith({Map<String, String>? parameters, Map<String, String>? query}) => Request<T>(
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

  Response<T> copyWith({
    Body<T>? body,
    int? statusCode,
    Headers? headers,
  }) =>
      Response(
        body: body ?? _body,
        statusCode: statusCode ?? this.statusCode,
        headers: headers ?? this.headers,
      );
}
