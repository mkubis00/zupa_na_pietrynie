import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/password_reset/cubit/password_reset_cubit.dart';
import 'package:zupa_na_pietrynie/password_reset/view/password_reset_form.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PasswordResetPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password reset'),
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
          create: (_) => PasswordResetCubit(context.read<AuthenticationRepository>()),
          child: const PasswordResetForm(),
        ),
      ),
    );
  }
}