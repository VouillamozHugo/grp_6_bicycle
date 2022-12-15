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

  LoginMessageState validatePassword(
      String password, String passwordConfirmation) {
    if (password.isEmpty) {
      return LoginMessageState("Fill in password.", false);
    }
    if (password != passwordConfirmation) {
      return LoginMessageState(
          "Confirmation password does not match the provided one.", false);
    }
    if (password.length < 8) {
      return LoginMessageState(
          "Password must have at least 8 characters.", false);
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
