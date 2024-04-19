import 'package:dext/src/router/tree.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('RouteTree', () {
    test("match root", () {
      final tree = RouteTree();
      tree.addRoute("/", emptyHandler);
      expect(tree.matchRoute('/'), isNotNull);
    });

    test("match full path", () {
      final tree = RouteTree();
      tree.addRoute("/api/users", emptyHandler);
      tree.addRoute("/api/users/abc", emptyHandler);

      expect(tree.matchRoute("/api/users"), isNotNull);
      expect(tree.matchRoute("/api/users/"), isNotNull);
    });

    test("partial matches does not work", () {
      final tree = RouteTree();
      tree.addRoute("/api/users/abc", emptyHandler);

      expect(tree.matchRoute("/api/users"), isNull);
      expect(tree.matchRoute("/api/users/"), isNull);
    });

    test("route parameters", () {
      final tree = RouteTree();
      tree.addRoute("/api/users", emptyHandler);
      tree.addRoute("/api/users/:userId/payments/:paymentId", emptyHandler);
      tree.addRoute("/api/users/:userId/orders/:orderId", emptyHandler);

      expect(tree.matchRoute("/api/users/123/payments"), isNull);
      expect(
          tree.matchRoute("/api/users/123/payments/444")!.parameters,
          equals({
            "userId": "123",
            "paymentId": "444",
          }));
    });

    test("skip trailing slash", () {
      final tree = RouteTree();
      tree.addRoute("/api/users", emptyHandler, "users");

      expect(tree.matchRoute("/api/users/"), isNotNull);
      expect(tree.matchRoute("/api/users"), isNotNull);
    });

    test("wildcard matching", () {
      final tree = RouteTree();
      tree.addRoute("/api/users", emptyHandler, "users");
      tree.addRoute("/api/*", emptyHandler, "api");
      tree.addRoute("/dashboard/*/payments", emptyHandler, "payments");
      tree.addRoute("*", emptyHandler, "global");

      expect(tree.matchRoute("/api/users/")!.node.name, equals("users"));
      expect(tree.matchRoute("/api/hello")!.node.name, equals("api"));
      expect(tree.matchRoute("/dashboard/anything/payments")!.node.name, equals("payments"));
      expect(tree.matchRoute("/dashboard/anything"), isNull);
      expect(tree.matchRoute("/anything")!.node.name, equals("global"));
    });

    test("regex parameter matching", () {
      final tree = RouteTree();
      tree.addRoute(r"/api/users/:userId[^[0-9]+$]", emptyHandler, "users");

      expect(tree.matchRoute("/api/users/asd"), isNull);
      expect(tree.matchRoute("/api/users/123"), isNotNull);
      expect(tree.matchRoute("/api/users/123das"), isNull);
      expect(tree.matchRoute("/api/users/1as23ds"), isNull);
      expect(tree.matchRoute("/api/users/123")!.parameters, equals({"userId": "123"}));
    });

    test("multiple parameters same route", () {
      final tree = RouteTree();
      tree.addRoute(r"/api/users/:userId[^[0-9]+$]", emptyHandler, "usersNumber");
      tree.addRoute(r"/api/users/:userId", emptyHandler, "users");

      expect(tree.matchRoute("/api/users/asd")!.node.name, equals("users"));
      expect(tree.matchRoute("/api/users/123")!.node.name, equals("usersNumber"));
      expect(tree.matchRoute("/api/users/123das")!.node.name, equals("users"));
      expect(tree.matchRoute("/api/users/1as23ds")!.node.name, equals("users"));
    });
  });
}
