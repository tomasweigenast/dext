import 'package:dext/src/http_method.dart';

final class NoRouteException implements Exception {
  final String message;

  const NoRouteException(String routePath, HttpMethod method) : message = "No route was found for $method: $routePath";

  @override
  String toString() => "NoRouteException($message)";
}
