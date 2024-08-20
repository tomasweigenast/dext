part of 'base_server.dart';

/// Context represents the execution context of a single request.
final class Context {
  /// A map of data that are passed between middlewares
  final Map<String, dynamic> data;

  Context._({Map<String, dynamic>? data}) : data = data == null ? DynamicMap(kImmutableTypes ? const {} : {}) : DynamicMap(data);

  Context copyWith({Map<String, dynamic>? data}) => Context._(
        data: data ?? this.data,
      );

  dynamic operator [](String key) => data[key];

  void operator []=(String key, dynamic value) {
    data[key] = value;
  }
}
