import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/home/home.dart';
import 'package:zupa_na_pietrynie/login/login.dart';

import '../../app/bloc/app_bloc.dart';
import '../../home/widgets/avatar.dart';
import '../cubit/settings_options_cubit.dart';

class SettingsOptionsForm extends StatefulWidget {
  const SettingsOptionsForm({Key? key}) : super(key: key);

  @override
  State<SettingsOptionsForm> createState() => _SettingsOptionsFormState();
}

class _SettingsOptionsFormState extends State<SettingsOptionsForm> {

  late bool isUserOptions = false;
  late bool isAppOptions = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final user = context.select((AppBloc bloc) => bloc.state.user);
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
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    "Ustawienia",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30
                    )                     ,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // SizedBox(width: width*0.85, child: _UserOptionsButton()),
              SizedBox(width: width*0.9, child:
              OutlinedButton(
                onPressed: () {
                  if (this.isUserOptions == false) {
                    this.isUserOptions = true;
                  } else {
                    this.isUserOptions = false;
                  }
                  setState(() {});
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Ustawienia użytkownika'),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Spacer(),
                    if (this.isUserOptions == false)
                      Icon(
                        Icons.add_box_outlined,
                        size: 24.0,
                      ) else
                      Icon(
                        Icons.add_box,
                        size: 24.0,
                      ),
                  ],
                ),
              )),
              if (this.isUserOptions) const SizedBox(height: 30),
              if (this.isUserOptions) Align(
                  alignment: Alignment.topCenter,
                  child: Avatar(photo: user.photo),
              ),
              if (this.isUserOptions) const SizedBox(height: 15),
              if (this.isUserOptions) const SizedBox(height: 8),
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _MailReset()),
              if (this.isUserOptions) const SizedBox(height: 8),
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _PasswordReset()),
              if (this.isUserOptions) const SizedBox(height: 30),
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _NameInput("")),
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _SaveNewName()),
              if (this.isUserOptions) const SizedBox(height: 8),
              SizedBox(width: width*0.9, child:
              OutlinedButton(
                onPressed: () {
                  if (this.isAppOptions == false) {
                    this.isAppOptions = true;
                  } else {
                    this.isAppOptions = false;
                  }
                  setState(() {});
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Ustawienia aplikacji'),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Spacer(),
                    if (this.isAppOptions == false)
                      Icon(
                        Icons.add_box_outlined,
                        size: 24.0,
                      ) else
                      Icon(
                        Icons.add_box,
                        size: 24.0,
                      ),
                  ],
                ),
              )),
              const SizedBox(height: 15),
              SizedBox(width: width*0.85, child: _LogoutButton()),
              const SizedBox(height: 15),
              SizedBox(
                  width: width*0.85,
                  child: Text(
                  "Masz pytania? Znalazleś blędy w aplikacji? \n "
                      "Wyslij nam e-mail na adres",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 15
                  ),
                  ),
                  ),
              SizedBox(
                width: width*0.85,
                child: Text(
                  "maciej.kubis00@gmail.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MailReset extends StatelessWidget {
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
            backgroundColor: const Color(0xFFFFFFFF),
          ),
          onPressed: () {},
          child: const Text('Zreseruj swój e-mail',
          style: TextStyle(color: Colors.black),),
        );
      },
    );
  }
}

class _PasswordReset extends StatelessWidget {
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
            backgroundColor: const Color(0xFFFFFFFF),
          ),
          onPressed: () {},
          child: const Text('Zreseruj swoje haslo',
          style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return
          TextFormField(
          initialValue: this.name,
          key: const Key('nameForm_nameInput_textField'),
          onChanged: (email) => context.read<SettingOptionsCubit>().nameChanged(email),
          keyboardType: TextInputType.name,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              helperText: '',
              errorText: state.name.invalid ? 'niepoprawna nazwa użytkownika' : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              // enabledBorder: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10)
              // )
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

class _SaveNewName extends StatelessWidget {
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
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color(0xFFFFFFFF),
          ),
          onPressed: () {},
          child: const Text('Zapisz nazwe użytkownika',
              style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}

// SizedBox(
// width: width*0.85,
// child:
// Align(
// alignment: Alignment.centerLeft,
// child: Container(
// child: Text(
// "Chcesz edytować swoje dane?",
// style: TextStyle(
// fontWeight: FontWeight.w900,
// fontSize: 30
// ),
// ),
// ),
// )
// ),
// const SizedBox(height: 8),
// SizedBox(
// width: width*0.85,
// child:
// Align(
// alignment: Alignment.centerLeft,
// child: Text(
// "Zmodyfikuj je tutaj",
// style: TextStyle(
// fontSize: 15
// ),
// ),
// ),
// ),
// const SizedBox(height: 35),
// Align(
// alignment: Alignment.topCenter,
// child: Avatar(photo: user.photo),
// ),
// const SizedBox(height: 25),
// SizedBox(
// width: width*0.85,
// child:
// Align(
// alignment: Alignment.centerLeft,
// child: Text(
// "E-mail",
// style: TextStyle(
// fontSize: 15
// ),
// ),
// ),
// ),
// SizedBox(width: width*0.85, child: _EmailInput(user.email)),
// const SizedBox(height: 8),
// SizedBox(
// width: width*0.85,
// child:
// Align(
// alignment: Alignment.centerLeft,
// child: Text(
// "Nazwa użytkownika",
// style: TextStyle(
// fontSize: 15
// ),
// ),
// ),
// ),
// SizedBox(width: width*0.85, child: _NameInput(user.name)),
// const SizedBox(height: 8),
// SizedBox(width: width*0.85, child: _SaveButton()),
// const SizedBox(height: 8),
// SizedBox(width: width*0.85, child: _LogoutButton()),

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
            backgroundColor: const Color(0xFF181313),
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
            backgroundColor: const Color(0xFF181313),
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
