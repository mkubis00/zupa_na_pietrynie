import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/login/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        LoginStrings.FACEBOOK_LOGIN_BUTTON,
        style: TextStyle(color: AppColors.WHITE),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.FACEBOOK_BLUE,
      ),
      icon: const Icon(FontAwesomeIcons.facebook, color: AppColors.WHITE),
      onPressed: () => context.read<LoginCubit>().logInWithFacebook(),
    );
  }
}
