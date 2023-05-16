class Validation {
  static userNameValidation(String value) {
    if (value == "" || value.isEmpty) {
      return "Please enter your name";
    }
    return null;
  }

  static emailValidation(String value) {
    RegExp regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (value == "") {
      return "Please enter your email address.";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid email address.";
    }

    return null;
  }

  static String? passwordValidation(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter your password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password should contain Capital,\nsmall letter & Number & Special';
      } else {
        return null;
      }
    }
  }
}
