import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:zupa_na_pietrynie/password_reset/password_reset.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? SizedBox(
                width: 30,
                height: 30,
                child: const CircularProgressIndicator(
                  color: AppColors.BLACK,
                ))
            : SizedBox(
                width: width * 0.85,
                child: ElevatedButton(
                  key: const Key('reset_button'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.BLACK,
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<PasswordResetCubit>().passwordReset()
                      : null,
                  child: const Text(PasswordResetString.RESET_PASSWORD_BUTTON),
                ));
      },
    );
  }

  ResetButton(this.width);

  final double width;
}
