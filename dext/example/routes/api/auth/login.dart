import 'package:dext/src/message.dart';

import '../../../models/user.dart';

Future<Response<User>> post() async {
  final user = User(
    id: "123",
    name: "User Name",
    email: "user_name@mail.com",
  );
  return Response.okd(user);
}
