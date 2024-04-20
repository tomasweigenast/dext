import 'package:dext/src/base_server.dart';
import 'package:dext/src/body.dart';
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
    router.get("/users", (request) => Response.ok(body: StringContent("list of users")));
    router.get("/users/:userId", (request) => Response.ok(body: StringContent("user: ${request.parameters["userId"]}")));
    router.all("*", (request) => Response.notFound(body: StringContent("not found")));
  }
}
