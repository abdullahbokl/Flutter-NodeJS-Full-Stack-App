class LoginModel {
  LoginModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  factory LoginModel.fromMap(dynamic json) => LoginModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "password": password,
      };
}
