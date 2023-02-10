import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../cubit/password_reset_cubit.dart';

class PasswordResetForm extends StatelessWidget {
  const PasswordResetForm({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Password reset Failure'),
              ),
            );
        } else if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Na podany adres e-mail wyślaliśmy link umożliwiający zresetowanie hasla."),
              ),
            );
          Navigator.of(context).pop();
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/bloc_logo_small.png',
                    height: 170,
                  )
              ),
              SizedBox(
                  width: width*0.85,
                  child:
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Nie pamiętasz hasla?",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30
                        ),
                      ),
                    ),
                  )
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: width*0.85,
                child:
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Zresetuj je",
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(width: width*0.85, child: _EmailInput()),
              const SizedBox(height: 8),
              SizedBox(width: width*0.85, child: _ResetButton()),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<PasswordResetCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: 'e-mail',
              helperText: '',
              errorText: state.email.invalid ? 'niepoprawny e-mail' : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(10)
              )
          ),
        );
      },
    );
  }
}

class _ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color(0xFFFFD600),
          ),
          onPressed: state.status.isValidated
              ? () => context.read<PasswordResetCubit>().passwordReset()
              : null,
          child: const Text('ZRESETUJ HASLO'),
        );
      },
    );
  }
}