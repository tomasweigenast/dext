import 'package:dext/src/middleware.dart';
import 'package:dext/src/router/route_handler.dart';

Middleware requestId() => (RouteHandler inner) {
      return (request) async {
        final randomId = DateTime.now().microsecondsSinceEpoch;
        request.context["request.id"] = randomId;
        final response = await inner(request);

        response.headersAll["X-Request-Id"] = [randomId.toString()];
        return response;
      };
    };
