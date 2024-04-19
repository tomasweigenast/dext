import 'dart:collection';

import 'package:dext/src/router/route_handler.dart';
import 'package:dext/src/router/route_match.dart';

final class RouteNode {
  final LinkedHashMap<String, RouteNode> children;
  final String pathPart;
  final RegExp? pathRegex;
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
    this.pathRegex,
    this.routeHandler,
  });

  @override
  String toString() => "RouteNode(pathPart: $pathPart)";

  @override
  int get hashCode => Object.hash(pathPart, pathRegex, isParameter, isWildcard, name, children.hashCode);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is RouteNode &&
          other.children == children &&
          other.pathPart == pathPart &&
          other.pathRegex == pathRegex &&
          other.isParameter == isParameter &&
          other.isWildcard == isWildcard &&
          name == other.name &&
          other.routeHandler == routeHandler);
}

final class RouteTree {
  final RouteNode root;

  RouteTree() : root = RouteNode(children: LinkedHashMap(), pathPart: "");

  void addRoute(String path, [RouteHandler? routeHandler, String? name]) {
    if (path[0] == "/") path = path.substring(1);
    if (path.endsWith("/")) path = path.substring(0, path.length - 1); // Remove trailing slash

    final parts = path.split("/");
    RouteNode current = root;

    for (final part in parts) {
      var next = current.children[part];
      if (next == null) {
        final isParam = part.isEmpty ? false : part[0] == ":";
        final isWildcard = part == "*";
        final firstBracket = part.indexOf('[');
        final lastBracket = firstBracket != -1 ? part.lastIndexOf(']') : -1;
        var finalPart = part;
        RegExp? regex;
        if (firstBracket != -1 && lastBracket != -1) {
          if (part.length - 1 > lastBracket) {
            throw FormatException("Route parameter that defines a regex cannot declare more arguments.");
          }
          regex = RegExp(part.substring(firstBracket + 1, lastBracket));
          finalPart = part.substring(0, firstBracket);
        }
        next = RouteNode(
          children: LinkedHashMap(),
          pathPart: isParam ? finalPart.substring(1) : finalPart,
          isParameter: isParam,
          isWildcard: isWildcard,
          pathRegex: regex,
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
            if (value.pathRegex != null && !value.pathRegex!.hasMatch(part)) {
              continue;
            }

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
