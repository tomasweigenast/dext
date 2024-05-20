import 'dart:io';

import 'server.dart';

Future<void> main() async {
  final server = Server();

  ProcessSignal.sigint.watch().listen((signal) async {
    print("Received signal $signal, shutting down gracefully...");
    await server.shutdown();
    print("Server stopped.");
    exit(0);
  });

  await server.run(InternetAddress.loopbackIPv4, 2020);
}
