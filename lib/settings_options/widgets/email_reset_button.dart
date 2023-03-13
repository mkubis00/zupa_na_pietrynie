import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/settings_options/settings_options.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class EmailResetButton extends StatelessWidget {
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
                child: CircularProgressIndicator(color: AppColors.BLACK))
            : SizedBox(
                width: width * 0.85,
                child: ElevatedButton(
                    key: const Key('loginForm_continue_raisedButton'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.WHITE,
                    ),
                    onPressed: state.emailStatus.isValidated
                        ? () => context
                            .read<SettingOptionsCubit>()
                            .updateUserEmail()
                        : null,
                    child: const Text(
                      SettingsOptionsStrings.SAVE_NEW_BUTTON,
                      style: TextStyle(color: AppColors.BLACK),
                    )),
              );
      },
    );
  }

  EmailResetButton(this.width);

  final double width;
}
