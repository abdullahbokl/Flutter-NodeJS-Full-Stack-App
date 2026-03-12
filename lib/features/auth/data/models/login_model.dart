class LoginModel {
  final String? email;
  final String? userName;
  final String password;

  LoginModel({
    this.email,
    this.userName,
    required this.password,
  });

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
        email: json["email"],
        userName: json["userName"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        if (email != null) "email": email,
        if (userName != null) "userName": userName,
        "password": password,
      };
}
