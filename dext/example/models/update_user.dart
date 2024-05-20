final class UpdateUser {
  final String name;

  UpdateUser({required this.name});

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}
