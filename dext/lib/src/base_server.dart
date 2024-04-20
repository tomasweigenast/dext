import 'dart:io';

import 'package:dext/src/body.dart';
import 'package:dext/src/http_method.dart';
import 'package:dext/src/message.dart';
import 'package:dext/src/router/router.dart';

abstract class BaseServer {
  final Router _router = Router();

  HttpServer? _server;

  /// The global settings for the server
  ServerSettings get settings;

  /// Starts the server listening on [address]
  Future<void> run(InternetAddress host, int port) async {
    if (_server != null) throw StateError("Server already started.");

    // setup server
    configureRoutes(_router);

    // startup
    _server = await HttpServer.bind(host, port);
    _server!.listen(_onRequest);
  }

  Future<void> shutdown() async {
    if (_server == null) throw StateError("Server has not been started.");
    await _server!.close();
  }

  Future<void> _onRequest(HttpRequest innerRequest) async {
    final uri = innerRequest.uri;
    print("Received request: $uri");

    final routeMatch = _router.match(uri.toString(),
        HttpMethod.values.firstWhere((element) => element.verb.toLowerCase() == innerRequest.method.toLowerCase()));

    // todo: if using BytesContent consider using content-length to allocate a initial buffer and then concat
    // each buffer.
    // final buffer = await innerRequest.fold(Uint8List(0), (previous, element) {
    //   final newBuffer = Uint8List(previous.length + element.length);
    //   newBuffer.setRange(0, previous.length, previous);
    //   newBuffer.setRange(previous.length, element.length, element);
    //   return newBuffer;
    // });

    Body? requestBody;
    requestBody = StreamContent(innerRequest);

    final headers = <String, List<String>>{};
    innerRequest.headers.forEach((name, values) {
      headers[name] = values;
    });

    final request = Request(
      uri: innerRequest.uri,
      query: innerRequest.uri.queryParameters,
      parameters: routeMatch.parameters,
      body: requestBody,
      headers: headers,
    );

    final response = await routeMatch.node.routeHandler!(request);
    innerRequest.response.statusCode = response.statusCode;
    innerRequest.response.contentLength = response.contentLength ?? -1;
    innerRequest.response.bufferOutput = true;
    if (response.contentLength == null) {
      innerRequest.response.headers.set(HttpHeaders.transferEncodingHeader, 'chunked');
    }

    await innerRequest.response.addStream(response.read());
    await innerRequest.response.close();
  }

  void configureRoutes(Router router);
}

final class ServerSettings {
  /// The path where the routes are declared.
  final String routesFolder;

  /// The path to the static folder assets.
  ///
  /// If null, no static files are served.
  final String? staticFolder;

  /// The value in the X-Powered-By header
  final String poweredByHeader;

  const ServerSettings({
    required this.routesFolder,
    this.staticFolder,
    this.poweredByHeader = "Dart with Dext",
  });
}
