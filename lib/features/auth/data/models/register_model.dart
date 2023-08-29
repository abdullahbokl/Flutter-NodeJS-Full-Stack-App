class RegisterModel {
  final String userName;
  final String email;
  final String password;

  RegisterModel({
    required this.userName,
    required this.email,
    required this.password,
  });

  factory RegisterModel.fromMap(dynamic json) => RegisterModel(
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "userName": userName,
        "email": email,
        "password": password,
      };
}
