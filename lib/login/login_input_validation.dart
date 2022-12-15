import 'package:grp_6_bicycle/login/login_message_state.dart';

class InputValidation {
  LoginMessageState validatEmail(String email) {
    if (email.isEmpty) {
      return LoginMessageState("Fill in email.", false);
    }

    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      return LoginMessageState("Incorrect email format.", false);
    }
    return LoginMessageState("", true);
  }

  LoginMessageState validatePassword(String password) {
    if (password.isEmpty) {
      return LoginMessageState("Fill in password.", false);
    }
    return LoginMessageState("", true);
  }

  LoginMessageState validateNames(String lastName, String firstName) {
    if (lastName.isNotEmpty && firstName.isNotEmpty) {
      return LoginMessageState("", true);
    }
    return LoginMessageState(
        "Fill in both first name and last name fields.", false);
  }
}
