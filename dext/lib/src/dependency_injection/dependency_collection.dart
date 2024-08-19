part 'service.dart';

final class DependencyCollection {
  final Map<int, _Service> _services;
  bool _locked = false;

  DependencyCollection() : _services = {};

  T? resolve<T extends Object>({String? name, bool forceNew = false}) {
    int id = T.hashCode;
    if (name != null) {
      id = _mixHashCodes(id, name.hashCode);
    }

    final service = _services[id];
    if (service == null) return null;

    return service.getValue(this, forceNew: forceNew) as T;
  }

  T mustResolve<T extends Object>({String? name, bool forceNew = false}) {
    final value = resolve<T>(name: name, forceNew: forceNew);
    if (value == null) throw UnimplementedError("Service $T was not implemented.");

    return value;
  }

  void lock() {
    _locked = true;
  }

  void addLazySingleton<T extends Object>(T Function(DependencyCollection services) fn, {String? name}) => _add(
        ServiceType.singleton,
        fn: fn,
        name: name,
      );

  void addSingleton<T extends Object>(T value, {String? name}) => _add(
        ServiceType.singleton,
        value: value,
        name: name,
      );

  void addTransient<T extends Object>(T Function(DependencyCollection services) fn, {String? name}) => _add(
        ServiceType.transient,
        fn: fn,
        name: name,
      );

  void addScoped<T extends Object>(T Function(DependencyCollection services) fn, {String? name}) => _add(
        ServiceType.scoped,
        fn: fn,
        name: name,
      );

  void _add<T extends Object>(ServiceType type, {T? value, T Function(DependencyCollection services)? fn, String? name}) {
    assert(!_locked, "Cannot add services to a locked DependencyCollection.");

    int id = T.hashCode;
    if (name != null) {
      id = _mixHashCodes(id, name.hashCode);
    }

    _services[id] = _Service<T>(type, value, fn);
  }

  @pragma("vm:prefer-inline")
  static int _mixHashCodes(int a, int b) {
    final int h1 = 0x1fffffff & (a + b);
    final int h2 = 0x1fffffff & (a + (0x7fffffff & (b << 3)));
    return h1 ^ h2;
  }
}
