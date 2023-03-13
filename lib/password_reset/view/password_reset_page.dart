import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/password_reset/password_reset.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PasswordResetPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.WHITE,
        shadowColor: AppColors.WHITE,
        elevation: 0,
        leading: BackButton(
          color: AppColors.BLACK,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) =>
              PasswordResetCubit(context.read<AuthenticationRepository>()),
          child: const PasswordResetForm(),
        ),
      ),
    );
  }
}
