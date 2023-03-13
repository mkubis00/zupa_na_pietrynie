import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/sign_up/sign_up.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        final String email = state.email.value;
        if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(SignUpString.snackBarAccountCreated(email)),
              ),
            );
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ??
                      SignUpString.SNACK_BAR_ACCOUNT_NOT_CREATED)),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -2 / 3),
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
                              SignUpString.MAIN_INSCRIPTION,
                              style:
                                  TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                            ),
                          ),
                        )),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: width * 0.85,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          SignUpString.SECOND_INSCRIPTION,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(width: width * 0.85, height: 55, child: EmailInput()),
                    const SizedBox(height: 15),
                    SizedBox(width: width * 0.85, height: 55, child: PasswordInput()),
                    const SizedBox(height: 15),
                    SizedBox(width: width * 0.85, height: 55, child: ConfirmPasswordInput()),
                    const SizedBox(height: 20),
                    SignUpButton(width),
          ],
        )),
      ),
    );
  }
}
