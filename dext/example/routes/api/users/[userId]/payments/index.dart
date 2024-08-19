// ignore_for_file: file_names

import 'package:dext/src/controller.dart';

import '../../../../../logger/logger_base.dart';

// this will handled as /api/users/{userId}/payments
Future<List<int>> get(String userId, LoggerBase logger) async {
  if (userId == "123") {
    notFound();
  }

  logger.log("debug", "Listing payments of $userId.");

  return [1, 2, 3, 4];
}
