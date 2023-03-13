import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/sign_up/sign_up.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: const Text(
        LoginStrings.SIGN_UP_BUTTON,
        style: TextStyle(
          color: AppColors.BLACK,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
