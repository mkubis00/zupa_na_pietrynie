import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/login/login.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          cursorColor: AppColors.BLACK,
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.BLACK)),
            labelText: LoginStrings.PASSWORD_INPUT_LABEL,
            labelStyle: const TextStyle(color: AppColors.BLACK),
            errorText: state.password.invalid
                ? LoginStrings.PASSWORD_INPUT_INVALID
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
