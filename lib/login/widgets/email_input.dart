import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/login/login.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          cursorColor: AppColors.BLACK,
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.BLACK)),
              labelText: LoginStrings.EMAIL_INPUT_LABEL,
              labelStyle: const TextStyle(color: AppColors.BLACK),
              errorText:
                  state.email.invalid ? LoginStrings.EMAIL_INPUT_INVALID : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(10))),
        );
      },
    );
  }
}
