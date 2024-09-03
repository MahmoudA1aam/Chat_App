class UserModel {
  String email;
  String name;

  UserModel({required this.email, required this.name});

  factory UserModel.fromFireStore(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      "name": name,
      "email": email,
    };
  }
}

