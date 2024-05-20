import 'dart:convert';

import 'package:dext/src/base_server.dart';
import 'package:dext/src/body.dart';
import 'package:dext/src/context.dart';
import 'package:dext/src/message.dart';
import 'package:dext/src/router/router.dart';

import 'routes/api/users/[userId].dart';

final class Server extends BaseServer {
  @override
  ServerSettings get settings => const ServerSettings(
        routesFolder: "routes",
        staticFolder: "static",
      );

  @override
  void configureRoutes(Router router) {
    router.get("/users", (request) => Response.ok(body: StringContent("list of users")));
    router.get("/users/:userId", (request) async {
      final controller = UsersController();
      final result = await controller.get(Context.def(), request.parameters["userId"]!);
      return Response.ok(body: StringContent.json(result.toJson()));
    });
    router.get("/users/:userId/payments", (request) => Response.ok(body: StreamContent(Stream.value(utf8.encode("hello guys")))));
    router.all("*", (request) => Response.notFound(body: StringContent("not found")));
  }
}
