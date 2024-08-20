import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dext/dext.dart';
import 'package:dext/src/body.dart';
import 'package:dext/src/constants.dart';
import 'package:dext/src/dynamic_map.dart';
import 'package:dext/src/exception/immutable_exception.dart';
import 'package:dext/src/extensions.dart';
import 'package:dext/src/headers.dart';
import 'package:dext/src/http_method.dart';

abstract class HttpMessage<T> {
  final Body<T> _body;
  final Headers _headers;
  ContentType? _contentType;

  Encoding? get encoding {
    var contentType = _contentType;
    if (contentType == null) return null;
    if (!contentType.parameters.containsKey('charset')) return null;
    return Encoding.getByName(contentType.parameters['charset']);
  }

  int? get contentLength => _body.contentLength;

  ContentType? get contentType {
    if (_contentType != null) return _contentType;
    final headerValue = _headers.flatten[HttpHeaders.contentTypeHeader];
    if (headerValue == null) return null;
    _contentType = ContentType.parse(headerValue);
    return _contentType;
  }

  Headers get headersAll => _headers;

  Map<String, String> get headers => _headers.flatten;

  HttpMessage({Body<T>? body, Map<String, List<String>>? headers})
      : _body = body ?? Body.empty(),
        _headers = Headers.from(_setBodyHeaders(headers, body));

  Stream<List<int>> read() => _body.read();

  Future<String> readAsString([Encoding? encoding]) async {
    encoding ??= this.encoding ?? utf8;
    return encoding.decodeStream(read());
  }

  static Map<String, List<String>> _setBodyHeaders(Map<String, List<String>>? headers, Body? body) {
    final Map<String, List<String>> newHeaders = headers == null ? {} : Map.from(headers);

    if (body == null) return newHeaders;

    // Set content-type header
    ContentType? contentType = _getContentType(newHeaders, body);
    if (contentType != null) {
      newHeaders[HttpHeaders.contentTypeHeader] = [contentType.toString()];
    }

    // now set content-length header

    return newHeaders;
  }

  /// Decides which content type to set in the final headers of the request/response. [headers] value are always more important.
  static ContentType? _getContentType(Map<String, List<String>> headers, Body? body) {
    // try to take the content type from the header
    String? rawHeaderContentType = headers[HttpHeaders.contentTypeHeader]?.firstOrNull;

    final ContentType? contentType;
    if (rawHeaderContentType == null) {
      contentType = body?.contentType;
    } else {
      contentType = ContentType.parse(rawHeaderContentType);
    }

    if (contentType == null) return null;

    // decide charset
    final Encoding? encoding = Encoding.getByName(contentType.charset) ?? body?.encoding;
    return ContentType(contentType.primaryType, contentType.subType, charset: encoding?.name);
  }

  /*
  bool _sameEncoding(Map<String, List<String>?>? headers, Body body) {
  if (body.encoding == null) return true;

  var contentType = findHeader(headers, 'content-type');
  if (contentType == null) return false;

  var charset = MediaType.parse(contentType).parameters['charset'];
  return Encoding.getByName(charset) == body.encoding;
}

  var sameEncoding = _sameEncoding(headers, body);
  if (sameEncoding) {
    if (body.contentLength == null ||
        findHeader(headers, 'content-length') == '${body.contentLength}') {
      return headers ?? Headers.empty();
    } else if (body.contentLength == 0 &&
        (headers == null || headers.isEmpty)) {
      return _defaultHeaders;
    }
  }

  var newHeaders = headers == null
      ? CaseInsensitiveMap<List<String>>()
      : CaseInsensitiveMap<List<String>>.from(headers);

  if (!sameEncoding) {
    if (newHeaders['content-type'] == null) {
      newHeaders['content-type'] = [
        'application/octet-stream; charset=${body.encoding!.name}'
      ];
    } else {
      final contentType =
          MediaType.parse(joinHeaderValues(newHeaders['content-type'])!)
              .change(parameters: {'charset': body.encoding!.name});
      newHeaders['content-type'] = [contentType.toString()];
    }
  }

  final explicitOverrideOfZeroLength =
      body.contentLength == 0 && findHeader(headers, 'content-length') != null;

  if (body.contentLength != null && !explicitOverrideOfZeroLength) {
    final coding = joinHeaderValues(newHeaders['transfer-encoding']);
    if (coding == null || equalsIgnoreAsciiCase(coding, 'identity')) {
      newHeaders['content-length'] = [body.contentLength.toString()];
    }
  }

  return newHeaders;
   */
}

final class Request<T> extends HttpMessage<T> {
  final Map<String, String> parameters;
  final Uri uri;
  final HttpMethod method;
  final Context context;

  Map<String, String> get queryParameters => uri.queryParameters;
  Map<String, List<String>> get queryParametersAll => uri.queryParametersAll;

  Request({
    required this.uri,
    required this.parameters,
    required this.method,
    required this.context,
    super.body,
    super.headers,
  });

  Request.fromStream(
    Stream<List<int>> stream, {
    required this.uri,
    required Map<String, String> parameters,
    required this.method,
    required this.context,
    required Map<String, List<String>> headers,
  })  : parameters = DynamicMap(parameters),
        super(
          headers: headers,
          body: StreamContent(stream, contentType: headers.getContentType()),
        );

  Request copyWith({Map<String, String>? parameters}) {
    return Request(
      uri: uri,
      context: context,
      method: method,
      headers: Headers.from(headersAll),
      parameters: parameters ?? this.parameters,
      body: _body,
    );
  }
}

final class Response<T> extends HttpMessage<T> {
  int _statusCode;

  int get statusCode => _statusCode;
  set statusCode(int statusCode) {
    if (kImmutableTypes) {
      throw const ImmutableException();
    }

    _statusCode = statusCode;
  }

  Response({
    required int statusCode,
    super.headers,
    super.body,
  }) : _statusCode = statusCode;

  Response.okd(T data) : this.ok(body: StringContent.json(data));
  Response.ok({Body<T>? body}) : this(statusCode: HttpStatus.ok, body: body);
  Response.notFound({Body<T>? body}) : this(statusCode: HttpStatus.notFound, body: body);
  Response.badRequest({Body<T>? body}) : this(statusCode: HttpStatus.badRequest, body: body);
}
