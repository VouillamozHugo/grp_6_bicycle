import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/login/register_page.dart';

import '../application_constants.dart';
import 'package:flutter/material.dart';

ButtonStyle formButtonStyle = OutlinedButton.styleFrom(
    side: const BorderSide(color: ApplicationConstants.BROWN));

class FormButton extends StatelessWidget {
  final Function onClickFunction;
  final String buttonText;
  const FormButton(
      {super.key, required this.onClickFunction, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () => onClickFunction,
        style: formButtonStyle,
        child: textCreator(buttonText, ApplicationConstants.ORANGE));
  }
}
