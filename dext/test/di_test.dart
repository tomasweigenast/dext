import 'dart:math';

import 'package:dext/src/dependency_injection/dependency_collection.dart';
import 'package:test/test.dart';

void main() {
  group("DependencyInjection", () {
    test("Resolve with type", () {
      final container = DependencyCollection()..addSingleton<_MyService>(_MyService(1));
      expect(container.resolve<_MyService>(), isNotNull);
    });

    test("Resolve with type and name", () {
      final container = DependencyCollection()
        ..addSingleton<_MyService>(_MyService(1))
        ..addSingleton<_MyService>(_MyService(2), name: "second");
      expect(container.mustResolve<_MyService>().id, equals(1));
      expect(container.mustResolve<_MyService>(name: "second").id, equals(2));
    });

    test("Scoped", () {
      final random = Random();
      final container = DependencyCollection()..addScoped<_MyService>((d) => _MyService(random.nextInt(100)));
      expect(container.mustResolve<_MyService>().id, isNot(equals(container.mustResolve<_MyService>(forceNew: true).id)));
      expect(container.mustResolve<_MyService>().id, equals(container.mustResolve<_MyService>().id));
    });
  });
}

final class _MyService {
  final int id;

  _MyService(this.id);
}
