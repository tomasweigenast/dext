import 'package:dext/src/constants.dart';

final class Logger {
  final String name;
  const Logger({required this.name});

  void debug(String text, {Map<String, Object?>? data}) {
    if (kDebugMode) {
      _log(LogLevel.debug, text, data: data);
    }
  }

  void info(String text, {Map<String, Object?>? data}) => _log(LogLevel.info, text, data: data);

  void warn(String text, {Map<String, Object?>? data}) => _log(LogLevel.warn, text, data: data);

  void error(String text, {Object? error, StackTrace? stackTrace, Map<String, Object?>? data}) =>
      _log(LogLevel.error, text, error: error, stackTrace: stackTrace, data: data);

  void _log(LogLevel level, String text, {Object? error, StackTrace? stackTrace, Map<String, Object?>? data}) {
    final msg = StringBuffer("[$name] [${DateTime.now()}] [${level.name}] -> $text");
    if (data != null) {
      msg.writeln("Data: $data");
    }

    if (error != null) {
      msg.writeln("Error: $error");
      msg.writeln("StackTrace: $stackTrace");
    }

    print(msg.toString());
  }
}

enum LogLevel {
  debug,
  info,
  warn,
  error,
}
