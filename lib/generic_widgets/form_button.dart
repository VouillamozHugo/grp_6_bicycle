import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/login/register_page.dart';

import '../application_constants.dart';

class FormButton extends StatelessWidget {
  const FormButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () => {},
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: ApplicationConstants.BROWN)),
        child: textCreator('Edit', ApplicationConstants.ORANGE));
  }
}
