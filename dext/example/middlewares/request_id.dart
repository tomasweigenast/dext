import 'package:dext/src/headers.dart';
import 'package:dext/src/middleware.dart';
import 'package:dext/src/router/route_handler.dart';

Middleware requestId() => (RouteHandler inner) {
      return (request) async {
        final randomId = DateTime.now().microsecondsSinceEpoch;
        final response = await inner(request.copyWith(
            context: request.context.copyWith(params: {
          ...request.context.params,
          "X-Request-Id": randomId,
        })));
        return response.copyWith(
            headers: Headers.from({
          ...response.headers,
          "X-Request-Id": [randomId.toString()],
        }));
      };
    };
