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
                    Text('Ustawienia użytkownika',
                    style: TextStyle(color: Colors.black)),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Spacer(),
                    if (this.isUserOptions == false)
                      Icon(
                        Icons.add_box_outlined,
                        size: 24.0,
                        color: Colors.black,
                      ) else
                      Icon(
                        Icons.add_box,
                        size: 24.0,
                        color: Colors.black,
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
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _MailInput("Test@test.com")),
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _MailReset()),
              if (this.isUserOptions) const SizedBox(height: 30),
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _NameInput("Test name")),
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _SaveNewName()),
              // if (this.isUserOptions) const SizedBox(height: 8),
              // if (this.isUserOptions) SizedBox(width: width*0.85, child: _PasswordReset()),
              if (this.isUserOptions) const SizedBox(height: 10),
              if (this.isUserOptions) SizedBox(width: width*0.85, child: _DeleteAccount()),
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
                    Text('Ustawienia aplikacji',
                    style: TextStyle(color: Colors.black)),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Spacer(),
                    if (this.isAppOptions == false)
                      Icon(
                        Icons.add_box_outlined,
                        size: 24.0,
                        color: Colors.black,
                      ) else
                      Icon(
                        Icons.add_box,
                        size: 24.0,
                        color: Colors.black,
                      ),
                  ],
                ),
              )),
              if (this.isAppOptions)  Text("Ustawienia aplikacji zostaną dodane wkrótce"),
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
              const SizedBox(height: 2),
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
              const SizedBox(height: 12),
              SizedBox(
                width: width*0.85,
                child: Text(
                  "Zupa na Pietrynie @ 2023",
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
          child: const Text('Zapisz nowy e-mail',
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
          child: const Text('Zmień swoje haslo',
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
            prefixText: "Nazwa użytkownika:",
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

class _MailInput extends StatelessWidget {
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
              prefixText: "E-mail:",
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

  _MailInput(String? name) {
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
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color(0xFFFFFFFF),
          ),
          onPressed: () {},
          child: const Text('Zapisz nazwę użytkownika',
              style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}

class _DeleteAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color(0xFFD21515),
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Usunięcie konta'),
          content: const Text('Czy na pewno chcesz usunąć swoje konto? Przywrócenie konta nie będzie możliwe.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed:
                  () {
                context.read<AppBloc>().add(const AppDeleteUserRequested());
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Usuń'),
            ),
          ],
        ),

      ),
      child: const Text('Usuń konto',
          style: TextStyle(color: Colors.white)),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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