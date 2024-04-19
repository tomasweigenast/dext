/// Context represents the execution context of a single request.
final class Context {
  /// A map of parameters that are passed between middlewares
  final Map<String, dynamic> params;

  const Context._({required this.params});
}
