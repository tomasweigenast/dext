import 'dart:io';

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
    assert(_server == null, "Server already started.");

    // setup server
    configureRoutes(_router);

    // startup
    _server = await HttpServer.bind(host, port);
    _server!.listen(_onRequest);
  }

  Future<void> shutdown() async {
    assert(_server != null, "Server has not been started.");

    await _server!.close();
  }

  Future<void> _onRequest(HttpRequest innerRequest) async {
    final uri = innerRequest.uri;
    print("Request received: $uri");

    final routeMatch = _router.match(uri.toString(),
        HttpMethod.values.firstWhere((element) => element.verb.toLowerCase() == innerRequest.method.toLowerCase()));

    final request = Request(
      uri: innerRequest.uri,
      query: innerRequest.uri.queryParameters,
      parameters: routeMatch.parameters,
    );

    final response = await routeMatch.node.routeHandler!(request);
    innerRequest.response.statusCode = response.statusCode;
    innerRequest.response.headers.contentType = response.contentType;
    if (response.body != null) innerRequest.response.add(response.body!);
    // innerRequest.response.writeln("""{"status": "success"}""");
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
