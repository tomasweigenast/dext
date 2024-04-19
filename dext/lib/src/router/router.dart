import 'package:dext/src/exception/no_route_exception.dart';
import 'package:dext/src/http_method.dart';
import 'package:dext/src/router/route_handler.dart';
import 'package:dext/src/router/route_match.dart';
import 'package:dext/src/router/tree.dart';

final class Router {
  final Map<HttpMethod, RouteTree> _trees = {};

  void get(String path, RouteHandler handler, {String? routeName}) {
    final methodTree = _trees[HttpMethod.get] ??= RouteTree();
    methodTree.addRoute(path, handler, routeName);
  }

  void post(String path, RouteHandler handler, {String? routeName}) {
    final methodTree = _trees[HttpMethod.post] ??= RouteTree();
    methodTree.addRoute(path, handler, routeName);
  }

  void put(String path, RouteHandler handler, {String? routeName}) {
    final methodTree = _trees[HttpMethod.put] ??= RouteTree();
    methodTree.addRoute(path, handler, routeName);
  }

  void delete(String path, RouteHandler handler, {String? routeName}) {
    final methodTree = _trees[HttpMethod.delete] ??= RouteTree();
    methodTree.addRoute(path, handler, routeName);
  }

  void patch(String path, RouteHandler handler, {String? routeName}) {
    final methodTree = _trees[HttpMethod.patch] ??= RouteTree();
    methodTree.addRoute(path, handler, routeName);
  }

  void head(String path, RouteHandler handler, {String? routeName}) {
    final methodTree = _trees[HttpMethod.head] ??= RouteTree();
    methodTree.addRoute(path, handler, routeName);
  }

  void all(String path, RouteHandler handler, {String? routeName}) {
    final methodTree = _trees[HttpMethod.$all] ??= RouteTree();
    methodTree.addRoute(path, handler, routeName);
  }

  RouteMatch? match(String path, HttpMethod method) {
    final methodTree = _trees[method] ?? _trees[HttpMethod.$all];

    // in this case we should throw an error that is returned to the client because
    // there is no route to be returned and handled. So let the default error handler
    // handle the exception
    if (methodTree == null) {
      throw NoRouteException(path, method);
    }

    return methodTree.matchRoute(path);
  }
}
