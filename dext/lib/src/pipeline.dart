import 'package:dext/src/middleware.dart';
import 'package:dext/src/router/route_handler.dart';

final class Pipeline {
  RouteHandler _handler;

  RouteHandler get handler => _handler;

  Pipeline(this._handler);

  Pipeline addMiddleware(Middleware middleware) {
    _handler = middleware(_handler);
    return this;
  }
}
/*
class _Pipeline extends Pipeline {
  final Middleware _middleware;
  final Middleware _parent;

  _Pipeline(this._middleware, this._parent);

  @override
  Handler addHandler(Handler handler) => _parent(_middleware(handler));
}
 */