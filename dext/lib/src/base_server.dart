import 'dart:io';

import 'package:dext/src/body.dart';
import 'package:dext/src/http_method.dart';
import 'package:dext/src/logger.dart';
import 'package:dext/src/message.dart';
import 'package:dext/src/router/route_handler.dart';
import 'package:dext/src/router/router.dart';

part 'root_handler.dart';

abstract class BaseServer {
  /// The default logger of the server
  static const Logger logger = Logger(name: "server");

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

    // handle requests
    // TODO: support multiple threads
    _handleRequests(_server!, _rootRouteHandler);

    logger.info("Server started at ${InternetAddress.loopbackIPv4.address}:2020");
  }

  Future<void> shutdown() async {
    if (_server == null) throw StateError("Server has not been started.");
    await _server!.close();
  }

  void configureRoutes(Router router);

  Future<Response> _rootRouteHandler(Request request) async {
    // TODO: after adding websockets, maybe this step is not neccessary and can be added back to root_handler.dart _onRequest method
    final routeMatch = _router.match(request.uri.toString(), request.method);
    return routeMatch.node.routeHandler!(request.copyWith(
      parameters: routeMatch.parameters,
    ));
  }
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
