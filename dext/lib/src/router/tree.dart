import 'package:dext/src/router/route_handler.dart';
import 'package:dext/src/router/route_match.dart';

final class RouteNode {
  final Map<String, RouteNode> children;
  final String pathPart;
  final bool isParameter;
  final bool isWildcard;
  final String? name;
  RouteHandler? routeHandler;

  RouteNode({
    required this.children,
    required this.pathPart,
    this.isParameter = false,
    this.isWildcard = false,
    this.name,
    this.routeHandler,
  });

  @override
  String toString() => "RouteNode(pathPart: $pathPart)";
}

final class RouteTree {
  final RouteNode root;

  RouteTree() : root = RouteNode(children: {}, pathPart: "");

  void addRoute(String path, [RouteHandler? routeHandler, String? name]) {
    if (path[0] == "/") path = path.substring(1);
    if (path.endsWith("/")) path = path.substring(0, path.length - 1); // Remove trailing slash

    final parts = path.split("/");
    RouteNode current = root;

    for (var part in parts) {
      var next = current.children[part];
      if (next == null) {
        final isParam = part.isEmpty ? false : part[0] == ":";
        final isWildcard = part == "*";
        next = RouteNode(
          children: {},
          pathPart: isParam ? part.substring(1) : path,
          isParameter: isParam,
          isWildcard: isWildcard,
          name: name,
        );
        current.children[part] = next;
      }

      current = next;
    }

    current.routeHandler = routeHandler;
  }

  void printTree() {
    void internalPrint(RouteNode node, int depth) {
      print("${Iterable.generate(depth, (_) => ' ').join("")}${node.isParameter ? ':${node.pathPart}' : node.pathPart}/");
      final newDepth = depth + 1;
      for (final child in node.children.values) {
        internalPrint(child, newDepth);
      }
    }

    internalPrint(root, 0);
  }

  RouteMatch? matchRoute(String path) {
    if (path[0] == "/") path = path.substring(1);
    // if (path.endsWith("/")) path = path.substring(0, path.length - 1); // Remove trailing slash

    final parts = path.split("/");
    RouteNode current = root;
    final capturedArguments = <String, String>{};

    loop:
    for (final part in parts) {
      RouteNode? next;

      // exact match
      next = current.children[part];
      if (next == null) {
        // iterate as it may be a parameter
        for (final value in current.children.values) {
          if (value.isParameter) {
            capturedArguments[value.pathPart] = part;
            current = value;
            continue loop;
          }
        }

        // wildcard
        next = current.children["*"];
      }

      if (next != null) {
        current = next;
      }
    }

    return current.routeHandler == null ? null : RouteMatch(node: current, parameters: capturedArguments);
  }
}
