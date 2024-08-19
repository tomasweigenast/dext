// ignore_for_file: file_names

import 'package:dext/dext.dart';
import 'package:dext/src/annotations/inject.dart';
import 'package:dext/src/controller.dart';

import '../../../../logger/logger_base.dart';
import '../../../../models/update_user.dart';
import '../../../../models/user.dart';

part 'index.g.dart';

// this will handled as /api/users/{userId}
@Inject(LoggerBase)
final class UserIdController extends _$UserIdController {
  UserIdController(super.server);

  Future<User> get(String userId) async {
    if (userId == "123") {
      notFound();
    }

    return User(id: userId, name: "User Name", email: "user_name@mail.com");
  }

  Future<User> patch(String userId, UpdateUser request) async {
    return User(id: userId, name: request.name, email: "user_name@mail.com");
  }
}
