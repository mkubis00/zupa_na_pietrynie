import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/home/home.dart';
import 'package:zupa_na_pietrynie/login/login.dart';

import '../../app/bloc/app_bloc.dart';
import '../../home/widgets/avatar.dart';
import '../cubit/settings_options_cubit.dart';

class SettingOptionsForm extends StatelessWidget {
  const SettingOptionsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    print(user.name);
    return BlocListener<SettingOptionsCubit, SettingOptionsState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'User credential failure'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: width*0.85,
                  child:
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Chcesz edytować swoje dane?",
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
                    "Zmodyfikuj je tutaj",
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Align(
                alignment: Alignment.topCenter,
                child: Avatar(photo: user.photo),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: width*0.85,
                child:
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "E-mail",
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                ),
              ),
              SizedBox(width: width*0.85, child: _EmailInput(user.email)),
              const SizedBox(height: 8),
              SizedBox(
                width: width*0.85,
                child:
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nazwa użytkownika",
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                ),
              ),
              SizedBox(width: width*0.85, child: _NameInput(user.name)),
              const SizedBox(height: 8),
              SizedBox(width: width*0.85, child: _SaveButton()),
              const SizedBox(height: 8),
              SizedBox(width: width*0.85, child: _LogoutButton()),
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
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          initialValue: this.email,
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<SettingOptionsCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
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

  _EmailInput(String? email) {
    this.email = email;
  }

  late final String? email;
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          initialValue: this.name,
          key: const Key('nameForm_nameInput_textField'),
          onChanged: (email) => context.read<SettingOptionsCubit>().nameChanged(email),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              helperText: '',
              errorText: state.name.invalid ? 'niepoprawna nazwa użytkownika' : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(10)
              )
          ),
        );
      },
    );
  }

  _NameInput(String? name) {
    this.name = name;
  }

  late final String? name;
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
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
          // onPressed: state.status.isValidated
          //     ? () => context.read<UserCredentialsCubit>().updateUserCredentials()
          //     : null,
          onPressed: () {
            if (state.status.isValidated) {
              context.read<SettingOptionsCubit>().updateUserCredentials();
            }
          },
                child: const Text('ZMODYFIKUJ DANE'),
        );
      },
    );
  }
}


class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
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
          onPressed: () {
            context.read<AppBloc>().add(const AppLogoutRequested());
            Navigator.pop(context);
          },
          child: const Text('WYLOGUJ SIĘ'),
        );
      },
    );
  }
}
