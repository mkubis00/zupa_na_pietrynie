import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/login/login.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          snackBarWarning(context, state.errorMessage ?? LoginStrings.SNACK_BAR_LOGIN_FAILURE);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1.8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topLeft,
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
                        LoginStrings.MAIN_INSCRIPTION,
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
                    LoginStrings.SECOND_INSCRIPTION,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(width: width * 0.85, child: EmailInput()),
              const SizedBox(height: 15),
              SizedBox(width: width * 0.85, child: PasswordInput()),
              const SizedBox(height: 20),
              LoginButton(width),
              const SizedBox(height: 8),
              SizedBox(width: width * 0.85, child: GoogleLoginButton()),
              const SizedBox(height: 8),
              SizedBox(width: width * 0.85, child: FacebookLoginButton()),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SignUpButton(),
                  const Text(LoginStrings.OR),
                  PasswordResetButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
