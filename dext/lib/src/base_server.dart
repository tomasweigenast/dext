import 'dart:collection';
import 'dart:io';

import 'package:dext/src/body.dart';
import 'package:dext/src/constants.dart';
import 'package:dext/src/dependency_injection/dependency_collection.dart';
import 'package:dext/src/dynamic_map.dart';
import 'package:dext/src/errors/http_error.dart';
import 'package:dext/src/http_method.dart';
import 'package:dext/src/logger.dart';
import 'package:dext/src/message.dart';
import 'package:dext/src/pipeline.dart';
import 'package:dext/src/router/route_handler.dart';
import 'package:dext/src/router/router.dart';

part 'request_handler.dart';
part 'context.dart';

abstract class BaseServer {
  /// The default logger of the server
  static const Logger logger = Logger(name: "server");

  // final Router _router = Router();
  final DependencyCollection _dependencyCollection = DependencyCollection();

  HttpServer? _server;

  /// Provides the list of registered services
  DependencyCollection get services => _dependencyCollection;

  /// Starts the server listening on [address]
  Future<void> run(InternetAddress host, int port) {
    Router router = Router();

    // setup server
    final pipeline = Pipeline(router.handle).addMiddleware(_errorHandlerMiddleware);
    configureMiddleware(pipeline);
    configureRoutes(router);

    return runPipeline(host, port, pipeline);
  }

  Future<void> runPipeline(InternetAddress host, int port, Pipeline pipeline) async {
    if (_server != null) throw StateError("Server already started.");

    // startup
    _server = await HttpServer.bind(host, port);

    // handle requests
    // TODO: support multiple threads (isolates)
    _handleRequests(_server!, pipeline.handler);

    logger.info("Server started at ${InternetAddress.loopbackIPv4.address}:$port");
  }

  Future<void> shutdown() async {
    if (_server == null) throw StateError("Server has not been started.");
    await _server!.close();
  }

  void configureRoutes(Router router);
  void configureMiddleware(Pipeline pipeline);

  RouteHandler _errorHandlerMiddleware(RouteHandler inner) {
    return (request) async {
      try {
        return await inner(request);
      } on HttpError catch (httpError) {
        return Response(statusCode: httpError.statusCode);
      } catch (err) {
        return Response(
          statusCode: HttpStatus.internalServerError,
          body: StringContent("An unhandled exception occurred."),
        );
      }
    };
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
