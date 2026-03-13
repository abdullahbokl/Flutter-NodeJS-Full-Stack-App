class RegisterModel {
  final String userName;
  final String email;
  final String password;
  final String role;
  final String? companyName;

  RegisterModel({
    required this.userName,
    required this.email,
    required this.password,
    this.role = 'seeker',
    this.companyName,
  });

  factory RegisterModel.fromMap(dynamic json) => RegisterModel(
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        role: json["role"] ?? 'seeker',
        companyName: json["companyName"],
      );

  Map<String, dynamic> toMap() => {
        "userName": userName,
        "email": email,
        "password": password,
        "role": role,
        if (companyName != null) "companyName": companyName,
      };
}
