import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/sign_up/sign_up.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const SizedBox(
                width: 30, height: 30, child: const CircularProgressIndicator(
          color: AppColors.BLACK,
        ))
            : SizedBox(
                width: width * 0.85,
                child: ElevatedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.BLACK,
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                      : null,
                  child: const Text(SignUpString.SIGN_UP_BUTTON),
                ));
      },
    );
  }

  SignUpButton(this.width);

  final double width;
}
