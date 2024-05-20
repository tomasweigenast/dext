// ignore_for_file: file_names

import 'package:dext/src/context.dart';
import 'package:dext/src/controller.dart';

import '../../../models/update_user.dart';
import '../../../models/user.dart';

// this will handled as /api/users/{userId}
final class UsersController extends Controller {
  Future<User> get(Context context, String userId) async {
    return User(id: userId, name: "User Name", email: "user_name@mail.com");
  }

  Future<User> patch(Context context, String userId, UpdateUser request) async {
    return User(id: userId, name: request.name, email: "user_name@mail.com");
  }
}
