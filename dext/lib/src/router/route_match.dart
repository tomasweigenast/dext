import 'package:dext/src/router/tree.dart';

final class RouteMatch {
  final RouteNode node;
  final Map<String, String> parameters;

  RouteMatch({required this.node, required this.parameters});

  @override
  String toString() => "Match: ${node.pathPart} [Parameters: $parameters]";
}
