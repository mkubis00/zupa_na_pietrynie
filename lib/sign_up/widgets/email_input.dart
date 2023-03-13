import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/sign_up/sign_up.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
            cursorColor: AppColors.BLACK,
            key: const Key('signUpForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<SignUpCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.BLACK)),
              labelText: SignUpString.EMAIN_INPUT_LABEL,
              labelStyle: const TextStyle(color: AppColors.BLACK),
              errorText:
                  state.email.invalid ? SignUpString.EMAIL_INPUT_INVALID : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(10)),
            ));
      },
    );
  }
}
