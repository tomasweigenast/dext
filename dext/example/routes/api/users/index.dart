// ignore_for_file: file_names

import '../../../models/user.dart';

// this will handled as /api/users
Future<List<User>> get() async {
  return [
    User(id: "1", name: "User Name", email: "user_name@mail.com"),
    User(id: "2", name: "User Name 2", email: "user_name_2@mail.com"),
  ];
}
