import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/settings_options/settings_options.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class SaveNewName extends StatelessWidget {
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
                child: CircularProgressIndicator(color: AppColors.BLACK))
            : SizedBox(
                width: width * 0.85,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.WHITE,
                  ),
                  onPressed: state.nameStatus.isValidated
                      ? () =>
                          context.read<SettingOptionsCubit>().updateUserName()
                      : null,
                  child: const Text(SettingsOptionsStrings.SAVE_USERNAME_BUTTON,
                      style: TextStyle(color: AppColors.BLACK)),
                ));
      },
    );
  }

  SaveNewName(this.width);

  final double width;
}
