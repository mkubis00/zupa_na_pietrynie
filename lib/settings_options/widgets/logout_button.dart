import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.GREEN,
      ),
      onPressed: () {
        context.read<AppBloc>().add(const AppLogoutRequested());
        Navigator.pop(context);
      },
      child: const Text(SettingsOptionsStrings.LOG_OUT_BUTTON),
    );
  }
}