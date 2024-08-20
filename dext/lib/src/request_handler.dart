part of 'base_server.dart';

void _handleRequests(Stream<HttpRequest> requests, RouteHandler rootHandler) {
// TODO: catch top level errors
  requests.listen((request) => _onRequest(request, rootHandler));
}

Future<void> _onRequest(HttpRequest rootRequest, RouteHandler rootHandler) async {
  BaseServer.logger.debug("Request to ${rootRequest.uri.path}");

  // Execute response
  final response = await rootHandler(_transformRequest(rootRequest));

  // configure outgoing response
  rootRequest.response.statusCode = response.statusCode;
  rootRequest.response.contentLength = response.contentLength ?? -1;
  rootRequest.response.headers.contentType = response.contentType;
  response.headers.forEach((key, value) {
    rootRequest.response.headers.add(key, value);
  });
  rootRequest.response.bufferOutput = true;

  // set chunked encoding if length is not known
  if (response.contentLength == null) {
    rootRequest.response.headers.set(HttpHeaders.transferEncodingHeader, 'chunked');
  }

  await rootRequest.response.addStream(response.read());
  await rootRequest.response.close();
}

@pragma('vm:prefer-inline')
Request _transformRequest(HttpRequest request) {
  final headers = <String, List<String>>{};
  request.headers.forEach((name, values) {
    headers[name] = values;
  });

  // todo: if using BytesContent consider using content-length to allocate a initial buffer and then concat
  // each buffer.
  // final buffer = await innerRequest.fold(Uint8List(0), (previous, element) {
  //   final newBuffer = Uint8List(previous.length + element.length);
  //   newBuffer.setRange(0, previous.length, previous);
  //   newBuffer.setRange(previous.length, element.length, element);
  //   return newBuffer;
  // });

  final requestMethod = HttpMethod.find(request.method);
  if (requestMethod == null) {
    throw StateError("Unsupported HTTP method: ${request.method}");
    // TODO: add better error type
  }

  return Request.fromStream(
    request,
    parameters: {},
    uri: request.uri,
    headers: headers,
    method: requestMethod,
    context: Context._(),
  );
}
