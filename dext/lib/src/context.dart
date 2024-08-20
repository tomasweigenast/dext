part of 'base_server.dart';

/// Context represents the execution context of a single request.
final class Context {
  /// A map of parameters that are passed between middlewares
  final Map<String, dynamic> params;

  /// Metadata that can be passed between middlewares
  final Map<String, dynamic> metadata;

  Context._({Map<String, dynamic>? params, Map<String, dynamic>? metadata})
      : params = params ?? {},
        metadata = metadata ?? {};

  Context copyWith({
    Map<String, dynamic>? params,
    Map<String, dynamic>? metadata,
  }) =>
      Context._(
        params: params,
        metadata: metadata,
      );
}
