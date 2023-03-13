import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class DeleteAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.RED,
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(SettingsOptionsStrings.ALERT_TITLE),
          content: const Text(SettingsOptionsStrings.ALERT_CONTENT),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(SettingsOptionsStrings.ALERT_NOT_DELETE_BUTTON,
                  style: TextStyle(color: AppColors.BLACK)),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(const AppDeleteUserRequested());
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
              child: const Text(SettingsOptionsStrings.ALERT_DELETE_BUTTON,
                  style: TextStyle(color: AppColors.RED)),
            ),
          ],
        ),
      ),
      child: const Text(SettingsOptionsStrings.DELTE_ACCOUNT_BUTTON,
          style: TextStyle(color: AppColors.WHITE)),
    );
  }
}
