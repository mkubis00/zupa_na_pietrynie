import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zupa_na_pietrynie/password_reset/password_reset.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          cursorColor: AppColors.BLACK,
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<PasswordResetCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.BLACK)),
              labelText: PasswordResetString.LABEL_EMAIL_INPUT,
              labelStyle: const TextStyle(color: AppColors.BLACK),
              errorText: state.email.invalid
                  ? PasswordResetString.INVALID_EMAIL
                  : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10))),
        );
      },
    );
  }
}
