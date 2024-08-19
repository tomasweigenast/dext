import 'dart:io';

import 'package:dext/src/annotations/service.dart';

import '../environments/environments.dart';

@singleton
abstract interface class LoggerBase {
  void log(String level, String message);
}

@implementation
final class ConsoleLogger implements LoggerBase {
  @override
  void log(String level, String message) => print("[${DateTime.now()}] [$level]: $message");
}

@productionImplementation
final class FileLogger implements LoggerBase {
  final IOSink _fileWriter;

  FileLogger() : _fileWriter = File("log.txt").openWrite(mode: FileMode.append);

  @override
  void log(String level, String message) {
    _fileWriter.writeln("[${DateTime.now()}] [$level]: $message");
  }
}
