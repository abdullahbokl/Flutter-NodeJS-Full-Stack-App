class DataValidator {
  // email validation

  static bool isValidEmail(data) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    return emailRegex.hasMatch(data);
  }

  static List<String> validateEmail(data) {
    final errors = <String>[];

    if (!data.contains("@")) {
      errors.add("Email must contain @");
    }

    if (!data.contains(".")) {
      errors.add("Email must contain .");
    }

    if (data.contains(" ")) {
      errors.add("Email must not contain spaces");
    }

    if (data.contains("\n")) {
      errors.add("Email must not contain new lines");
    }

    if (errors.isNotEmpty) return errors;

    // validate lengths

    final parts = data.split("@");
    final domainParts = parts[1].split(".");
    final username = parts[0];
    final topLevelDomain = domainParts[1];

    if (username.length < 3) {
      errors.add("Email must contain a username with at least 3 characters");
    }

    if (topLevelDomain.length < 2) {
      errors.add(
          "Email must contain a top-level domain with at least 2 characters");
    }

    if (domainParts[0].length < 2) {
      errors.add("Email must contain a domain with at least 1 character");
    }

    return errors;
  }

  // password validation

  static bool isValidPassword(data) {
    final passwordRegex = RegExp(
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$");
    return passwordRegex.hasMatch(data);
  }

  static List<String> validatePassword(data) {
    final errors = <String>[];

    if (!RegExp(r"^.{8,}$").hasMatch(data)) {
      errors.add("Password must be at least 8 characters");
    }

    if (!RegExp(r"[a-z]").hasMatch(data)) {
      errors.add("Password must contain at least 1 lowercase letter");
    }

    if (!RegExp(r"[A-Z]").hasMatch(data)) {
      errors.add("Password must contain at least 1 uppercase letter");
    }

    if (!RegExp(r"\d").hasMatch(data)) {
      errors.add("Password must contain at least 1 number");
    }

    if (!RegExp(r"[!@#$%^&*]").hasMatch(data)) {
      errors.add("Password must contain at least 1 symbol (!@#\$%^&*)");
    }

    return errors;
  }

  // username validation

  static bool isValidUserName(data) {
    return data.length >= 3;
  }

  static List<String> validateUserName(data) {
    final errors = <String>[];

    if (data.length < 3) {
      errors.add("Username must be at least 3 characters");
    }

    return errors;
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r"^[0-9]{10}$").hasMatch(phoneNumber);
  }
}
