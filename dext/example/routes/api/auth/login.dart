import 'package:dext/src/controller.dart';
import 'package:dext/src/message.dart';

import '../../../models/user.dart';

Future<Response<User>> post(Request request) async {
  if (request.contentLength == null) {
    throw badRequest();
  }

  final user = User(
    id: "123",
    name: "User Name",
    email: "user_name@mail.com",
  );
  return Response.okd(user);
}
