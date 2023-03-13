import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/settings_options/settings_options.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          initialValue: this.name,
          cursorColor: AppColors.BLACK,
          key: const Key('nameForm_nameInput_textField'),
          onChanged: (email) =>
              context.read<SettingOptionsCubit>().emailChanged(email),
          keyboardType: TextInputType.name,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.BLACK)),
            prefixText: SettingsOptionsStrings.EMAIL_INPUT_PREFIX,
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            helperText: '',
            errorText: state.name.invalid
                ? SettingsOptionsStrings.EMAIL_INPUT_ERROR
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }

  EmailInput(String? name) {
    this.name = name;
  }

  late final String? name;
}
