import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zupa_na_pietrynie/settings_options/settings_options.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class SettingOptionsPage extends StatelessWidget {
  const SettingOptionsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingOptionsPage());
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
          create: (_) => SettingOptionsCubit(context.read<AuthenticationRepository>()),
          child: SettingsOptionsForm()
        ),
      ),
    );
  }
}
