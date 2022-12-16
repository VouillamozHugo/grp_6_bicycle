import 'package:grp_6_bicycle/login/input_message_state.dart';

class InputValidation {
  InputMessageState validatEmail(String email) {
    if (email.isEmpty) {
      return InputMessageState("Fill in email.", false);
    }

    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      return InputMessageState("Incorrect email format.", false);
    }
    return InputMessageState(null, true);
  }

  InputMessageState validatePassword(
      String password, String passwordConfirmation) {
    if (password.isEmpty) {
      return InputMessageState("Fill in password.", false);
    }
    if (password != passwordConfirmation) {
      return InputMessageState("Confirmation password does not match.", false);
    }
    if (password.length < 8) {
      return InputMessageState(
          "Password must have at least 8 characters.", false);
    }
    return InputMessageState(null, true);
  }

  InputMessageState validateFirstName(String firstName) {
    if (firstName.isEmpty) {
      return InputMessageState("Fill in first name.", false);
    }
    return InputMessageState(null, true);
  }

  InputMessageState validateLastName(String lastName) {
    if (lastName.isEmpty) {
      return InputMessageState("Fill in last name.", false);
    }
    return InputMessageState(null, true);
  }
}
