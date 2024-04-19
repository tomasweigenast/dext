import 'package:dext/src/exception/no_route_exception.dart';
import 'package:dext/src/http_method.dart';
import 'package:dext/src/router/router.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group("Router", () {
    test("method and path found", () {
      final router = Router();
      router.get("/users/:userId", emptyHandler);

      expect(router.match("/users/userId", HttpMethod.get), isNotNull);
    });

    test("exception if no route found", () {
      final router = Router();
      router.get("/users/:userId", emptyHandler);

      expect(() => router.match("/users/userId", HttpMethod.post), throwsA(isA<NoRouteException>()));
    });

    test("fallback route", () {
      final router = Router();
      router.get("/users/:userId", emptyHandler);
      router.all("/users/:userId", emptyHandler, routeName: "fallback");

      expect(router.match("/users/userId", HttpMethod.post).node.name, equals("fallback"));
    });

    test("global fallback route", () {
      final router = Router();
      router.post("/users/:userId", emptyHandler);
      router.all("*", emptyHandler, routeName: "notFound");

      expect(router.match("/users/userId", HttpMethod.get).node.name, equals("notFound"));
    });
  });
}
