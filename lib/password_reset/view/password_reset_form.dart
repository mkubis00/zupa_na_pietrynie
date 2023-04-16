import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/password_reset/password_reset.dart';

class PasswordResetForm extends StatelessWidget {
  const PasswordResetForm({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          snackBarWarning(
              context, PasswordResetString.SNACK_BAR_PASSWORD_RESET_FAILURE);
        } else if (state.status.isSubmissionSuccess) {
          snackBarSuccess(
              context, PasswordResetString.SNACK_BAR_RESET_EMAIL_SENDED);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/bloc_logo_small.png',
                    height: 170,
                  )),
              SizedBox(
                  width: width * 0.85,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: const Text(
                        PasswordResetString.MAIN_INSCRIPTION,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 30),
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
              SizedBox(
                width: width * 0.85,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    PasswordResetString.SECOND_INSCRIPTION,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(width: width * 0.85, child: EmailInput()),
              const SizedBox(height: 8),
              ResetButton(width),
            ],
          ),
        ),
      ),
    );
  }
}
