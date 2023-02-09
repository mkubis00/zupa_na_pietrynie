import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/settings_options/view/settings_optins_form.dart';

import '../cubit/settings_options_cubit.dart';



class SettingOptionsPage extends StatelessWidget {
  const SettingOptionsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingOptionsPage());
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
          create: (_) => SettingOptionsCubit(context.read<AuthenticationRepository>()),
          child: SettingsOptionsForm()
        ),
      ),
    );
  }
}
