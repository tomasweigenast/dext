import 'package:dext/dext.dart';
import 'package:dext/src/logger.dart';
import 'package:dext/src/middleware.dart';
import 'package:dext/src/router/route_handler.dart';

Middleware log([Logger? logger]) => (RouteHandler inner) {
      return (request) async {
        (logger ?? BaseServer.logger)
            .info("Request received [${request.uri.path}] Method [${request.method.name}] Content Type [${request.contentType}]");
        return await inner(request);
      };
    };
