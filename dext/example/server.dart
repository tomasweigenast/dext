import 'dart:convert';

import 'package:dext/src/base_server.dart';
import 'package:dext/src/message.dart';
import 'package:dext/src/router/router.dart';

final class Server extends BaseServer {
  @override
  ServerSettings get settings => const ServerSettings(
        routesFolder: "routes",
        staticFolder: "static",
      );

  @override
  void configureRoutes(Router router) {
    router.get("/users", (request) => Response(body: utf8.encode("list of users")));
    router.get("/users/:userId", (request) => Response(body: utf8.encode("user: ${request.parameters["userId"]}")));
    router.all("*", (request) => Response(body: utf8.encode("not found")));
  }
}
