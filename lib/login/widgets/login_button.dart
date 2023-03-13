import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/login/login.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(color: AppColors.BLACK))
            : SizedBox(
                width: width * 0.85,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.BLACK,
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                  child: const Text(LoginStrings.LOGIN_IN_BUTTON),
                ));
      },
    );
  }

  LoginButton(this.width);

  final double width;
}
