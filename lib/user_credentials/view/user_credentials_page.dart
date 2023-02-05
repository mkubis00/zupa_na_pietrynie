import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/user_credentials/cubit/user_credentials_cubit.dart';
import 'package:zupa_na_pietrynie/user_credentials/view/user_credentials_form.dart';


class UserCredentialsPage extends StatelessWidget {
  const UserCredentialsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const UserCredentialsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User credential'),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black87,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => UserCredentialsCubit(context.read<AuthenticationRepository>()),
          child: const UpdateUserCredentialsForm(),
        ),
      ),
    );
  }
}
