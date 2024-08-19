import 'dart:convert';

import 'package:dext/src/base_server.dart';
import 'package:dext/src/body.dart';
import 'package:dext/src/message.dart';
import 'package:dext/src/router/router.dart';

import 'logger/logger_base.dart';
import 'middlewares/log_middleware.dart';
import 'models/update_user.dart';
import 'routes/api/users/[userId]/index.dart';
import 'routes/api/users/[userId]/payments/index.dart' as $payments;
import 'routes/api/users/index.dart' as $users;
import 'routes/api/auth/login.dart' as $auth_login;

final class Server extends BaseServer {
  @override
  ServerSettings get settings => const ServerSettings(
        routesFolder: "routes",
        staticFolder: "static",
      );

  @override
  void configureRoutes(Router router) {
    router.get("/api/users", (request) async {
      final result = await $users.get();
      return Response.ok(body: StringContent.json(result.map((user) => user.toJson()).toList()));
    });
    router.get("/api/users/:userId", (request) async {
      final controller = UserIdController(this);
      controller.request = request;
      final result = await controller.get(request.parameters["userId"]!);
      return Response.ok(body: StringContent.json(result.toJson()));
    });
    router.patch("/api/users/:userId", (request) async {
      final controller = UserIdController(this);
      final UpdateUser body = UpdateUser.fromJson(jsonDecode(await request.readAsString()));
      controller.request = request;
      final result = await controller.patch(request.parameters["userId"]!, body);
      return Response.ok(body: StringContent.json(result.toJson()));
    });
    router.get("/api/users/:userId/payments", (request) async {
      final result = await $payments.get(
        request.parameters["userId"]!,
        services.mustResolve<LoggerBase>(),
      );
      return Response.ok(body: StringContent.json(result));
    });
    router.post("/api/auth", (request) => $auth_login.post());
    router.all("*", (request) => Response.notFound(body: StringContent("not found")), middleware: logMiddleware());
  }
}
