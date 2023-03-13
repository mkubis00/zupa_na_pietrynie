import 'package:flutter/material.dart';

import 'package:zupa_na_pietrynie/password_reset/password_reset.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class PasswordResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () =>
          Navigator.of(context).push<void>(PasswordResetPage.route()),
      child: const Text(
        LoginStrings.PASSWORD_RESET_BUTTON,
        style: TextStyle(
          color: AppColors.BLACK,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}