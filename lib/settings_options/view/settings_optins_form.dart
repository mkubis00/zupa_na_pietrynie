import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/home/home.dart';

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
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocListener<SettingOptionsCubit, SettingOptionsState>(
      listener: (context, state) {
        if (state.emailStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'User credential failure'),
              ),
            );
        } else if (state.emailStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Zaktualizowano email użytkownika"),
              ),
            );
        } else if (state.nameStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Zaktualizowano nazwę użytkownika"),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    "Ustawienia",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: width * 0.9,
                  child: OutlinedButton(
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
                          )
                        else
                          Icon(
                            Icons.add_box,
                            size: 24.0,
                            color: Colors.black,
                          ),
                      ],
                    ),
                  )),
              if (this.isUserOptions) const SizedBox(height: 30),
              if (this.isUserOptions)
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Avatar(photo: user.photo),
                // ),
                _AvatarButton(user),
              if (this.isUserOptions) const SizedBox(height: 23),
              if (this.isUserOptions)
                SizedBox(width: width * 0.85, child: _MailInput(user.email)),
              if (this.isUserOptions)
                // SizedBox(width: width * 0.2, child: _MailReset()),
                _MailReset(width),
              if (this.isUserOptions) const SizedBox(height: 30),
              if (this.isUserOptions)
                SizedBox(width: width * 0.85, child: _NameInput(user.name)),
              if (this.isUserOptions) _SaveNewName(width),
              // if (this.isUserOptions) const SizedBox(height: 8),
              // if (this.isUserOptions) SizedBox(width: width*0.85, child: _PasswordReset()),
              if (this.isUserOptions) const SizedBox(height: 10),
              if (this.isUserOptions)
                SizedBox(width: width * 0.85, child: _DeleteAccount()),
              if (this.isUserOptions) const SizedBox(height: 8),
              SizedBox(
                  width: width * 0.9,
                  child: OutlinedButton(
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
                          )
                        else
                          Icon(
                            Icons.add_box,
                            size: 24.0,
                            color: Colors.black,
                          ),
                      ],
                    ),
                  )),
              if (this.isAppOptions)
                Text("Ustawienia aplikacji zostaną dodane wkrótce"),
              const SizedBox(height: 15),
              SizedBox(width: width * 0.85, child: _LogoutButton()),
              const SizedBox(height: 15),
              SizedBox(
                width: width * 0.85,
                child: Text(
                  "Masz pytania? Znalazleś/aś bląd w aplikacji? \n "
                  "Wyslij nam e-mail na adres",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: width * 0.85,
                child: Text(
                  "maciej.kubis00@gmail.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: width * 0.85,
                child: Text(
                  "Zupa na Pietrynie @ 2023",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
        buildWhen: (previous, current) =>
            previous.photoStatus != current.photoStatus,
        builder: (context, state) {
          return state.photoStatus.name == "photoUpdateInProgress"
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.black))
              : MaterialButton(
                  onLongPress: () =>
                      context.read<SettingOptionsCubit>().updateUserPhoto(),
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Avatar(photo: user.photo),
                  ),
                );
        });
  }

  _AvatarButton(this.user);

  final User user;
}

class _MailReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
      buildWhen: (previous, current) =>
          previous.emailStatus != current.emailStatus,
      builder: (context, state) {
        return state.emailStatus.isSubmissionInProgress
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.black))
            : SizedBox(
                width: width * 0.85,
                child: ElevatedButton(
                    key: const Key('loginForm_continue_raisedButton'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFFFFFFFF),
                    ),
                    onPressed: state.emailStatus.isValidated
                        ? () => context
                            .read<SettingOptionsCubit>()
                            .updateUserEmail()
                        : null,
                    child: const Text(
                      'Zapisz nowy e-mail',
                      style: TextStyle(color: Colors.black),
                    )),
              );
      },
    );
  }

  _MailReset(this.width);

  final double width;
}

// class _PasswordReset extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
//       buildWhen: (previous, current) => previous.status != current.status,
//       builder: (context, state) {
//         return state.status.isSubmissionInProgress
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//                 key: const Key('loginForm_continue_raisedButton'),
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   backgroundColor: const Color(0xFFFFFFFF),
//                 ),
//                 onPressed: () {},
//                 child: const Text('Zmień swoje haslo',
//                     style: TextStyle(color: Colors.black)),
//               );
//       },
//     );
//   }
// }

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
          initialValue: this.name,
          key: const Key('nameForm_nameInput_textField'),
          onChanged: (name) =>
              context.read<SettingOptionsCubit>().nameChanged(name),
          keyboardType: TextInputType.name,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            prefixText: "Nazwa użytkownika:",
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            helperText: '',
            errorText:
                state.name.invalid ? 'niepoprawna nazwa użytkownika' : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          initialValue: this.name,
          key: const Key('nameForm_nameInput_textField'),
          onChanged: (email) =>
              context.read<SettingOptionsCubit>().emailChanged(email),
          keyboardType: TextInputType.name,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            prefixText: "E-mail:",
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            helperText: '',
            errorText:
                state.name.invalid ? 'niepoprawna nazwa użytkownika' : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      buildWhen: (previous, current) =>
          previous.nameStatus != current.nameStatus,
      builder: (context, state) {
        return state.nameStatus.isSubmissionInProgress
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.black))
            : SizedBox(
                width: width * 0.85,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xFFFFFFFF),
                  ),
                  onPressed: state.nameStatus.isValidated
                      ? () =>
                          context.read<SettingOptionsCubit>().updateUserName()
                      : null,
                  child: const Text('Zapisz nazwę użytkownika',
                      style: TextStyle(color: Colors.black)),
                ));
      },
    );
  }

  _SaveNewName(this.width);

  final double width;
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
          content: const Text(
              'Czy na pewno chcesz usunąć swoje konto? Przywrócenie konta nie będzie możliwe.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Anuluj', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(const AppDeleteUserRequested());
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
              child: const Text('Usuń', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      child: const Text('Usuń konto', style: TextStyle(color: Colors.white)),
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
