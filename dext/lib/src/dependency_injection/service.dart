part of 'dependency_collection.dart';

final class _Service<T extends Object> {
  final ServiceType _type;
  final T Function(DependencyCollection)? _generatorFn;
  T? _value;

  _Service(this._type, this._value, this._generatorFn);

  T getValue(DependencyCollection collection, {bool forceNew = false}) {
    switch (_type) {
      case ServiceType.singleton:
        _value ??= _generatorFn!(collection);
        return _value!;

      case ServiceType.transient:
        return _generatorFn!(collection);

      case ServiceType.scoped:
        if (forceNew || _value == null) {
          _value = _generatorFn!(collection);
        }

        return _value!;
    }
  }
}

enum ServiceType {
  singleton,
  transient,
  scoped,
}
