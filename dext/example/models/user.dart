import 'package:dext/src/annotations/model.dart';

@model
final class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  Map toJson() => {"id": id, "name": name, "email": email};
}
