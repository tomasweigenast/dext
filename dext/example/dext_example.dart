import 'dart:io';

import 'package:dext/dext.dart';

Future<void> main() async {
  final server = Server.localhost();

  ProcessSignal.sigint.watch().listen((signal) async {
    print("Received signal $signal, shutting down gracefully...");
    await server.stop();
    print("Server stopped.");
    exit(0);
  });

  await server.run();

  print("Server started.");
}
