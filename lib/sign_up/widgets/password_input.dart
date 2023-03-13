import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/sign_up/sign_up.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          cursorColor: AppColors.BLACK,
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.BLACK)),
            labelText: SignUpString.PASSWORD_INPUT_LABEL,
            labelStyle: const TextStyle(color: AppColors.BLACK),
            errorText: state.password.invalid
                ? SignUpString.PASSWORD_INPUT_INVALID
                : null,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }
}
