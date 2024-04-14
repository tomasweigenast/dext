import 'dart:io';

final class Server {
  late final HttpServer _server;
  final int port;
  final String host;

  Server(this.host, this.port);
  Server.localhost([this.port = 5478]) : host = "localhost";

  Future<void> run() async {
    _server = await HttpServer.bind(host, port);
    _server.listen(_onRequest);
  }

  Future<void> stop() async {
    await _server.close();
  }

  Future<void> _onRequest(HttpRequest request) async {
    print("Request received: ${request.uri}");
    request.response.statusCode = HttpStatus.ok;
    request.response.headers.contentType = ContentType.json;
    request.response.writeln("""{"status": "success"}""");
    await request.response.close();
  }
}
