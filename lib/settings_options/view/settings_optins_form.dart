import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/settings_options/settings_options.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class SettingsOptionsForm extends StatefulWidget {
  const SettingsOptionsForm({Key? key}) : super(key: key);

  @override
  State<SettingsOptionsForm> createState() => _SettingsOptionsFormState();
}

class _SettingsOptionsFormState extends State<SettingsOptionsForm> {
  late bool isUserOptions = false;
  late bool isAppOptions = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    final loginProvider = context.select((AppBloc bloc) => bloc.state.loginProvider);
    return BlocListener<SettingOptionsCubit, SettingOptionsState>(
      listener: (context, state) {
        if (state.emailStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ??
                    SettingsOptionsStrings.SNACK_BAR_USER_CREADENTIAL_ERROR),
              ),
            );
        } else if (state.emailStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content:
                    const Text(SettingsOptionsStrings.SNACK_BAR_EMAIL_UPDATED),
              ),
            );
        } else if (state.nameStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content:
                    const Text(SettingsOptionsStrings.SNACK_BAR_NAME_UPDATED),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: const Text(
                    SettingsOptionsStrings.MAIN_INSCRIPTION,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: width * 0.9,
                  child: OutlinedButton(
                    onPressed: () {
                      if (this.isUserOptions == false) {
                        this.isUserOptions = true;
                      } else {
                        this.isUserOptions = false;
                      }
                      setState(() {});
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                            SettingsOptionsStrings.FIRST_SETTINGS_SECTION_NAME,
                            style: TextStyle(color: AppColors.BLACK)),
                        Spacer(),
                        if (this.isUserOptions == false)
                          const Icon(
                            IconData(0xf82b, fontFamily: 'MaterialIcons'),
                            size: 24.0,
                            color: AppColors.BLACK,
                          )
                        else
                          const Icon(
                            IconData(0xf82e, fontFamily: 'MaterialIcons'),
                            size: 24.0,
                            color: AppColors.BLACK,
                          ),
                      ],
                    ),
                  )),
              if (this.isUserOptions) const SizedBox(height: 30),
              if (this.isUserOptions) AvatarButton(user),
              if (this.isUserOptions) const SizedBox(height: 23),
              if (this.isUserOptions && loginProvider == 'password')
                SizedBox(width: width * 0.85, child: EmailInput(user.email)),
              if (this.isUserOptions && loginProvider == 'password') EmailResetButton(width),
              if (this.isUserOptions && loginProvider == 'password') const SizedBox(height: 30),
              if (this.isUserOptions)
                SizedBox(width: width * 0.85, child: NameInput(user.name)),
              if (this.isUserOptions) SaveNewName(width),
              // if (this.isUserOptions) const SizedBox(height: 8),
              // if (this.isUserOptions) SizedBox(width: width*0.85, child: _PasswordReset()),
              if (this.isUserOptions) const SizedBox(height: 10),
              if (this.isUserOptions)
                SizedBox(width: width * 0.85, child: DeleteAccount()),
              if (this.isUserOptions) const SizedBox(height: 8),
              SizedBox(
                  width: width * 0.9,
                  child: OutlinedButton(
                    onPressed: () {
                      if (this.isAppOptions == false) {
                        this.isAppOptions = true;
                      } else {
                        this.isAppOptions = false;
                      }
                      setState(() {});
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                            SettingsOptionsStrings.SECOND_SETTINGS_SECTION_NAME,
                            style: TextStyle(color: AppColors.BLACK)),
                        Spacer(),
                        if (this.isAppOptions == false)
                          const Icon(
                            IconData(0xf82b, fontFamily: 'MaterialIcons'),
                            size: 24.0,
                            color: AppColors.BLACK,
                          )
                        else
                          const Icon(
                            IconData(0xf82e, fontFamily: 'MaterialIcons'),
                            size: 24.0,
                            color: AppColors.BLACK,
                          ),
                      ],
                    ),
                  )),
              if (this.isAppOptions)
                const Text(SettingsOptionsStrings.TEMP_SETTIONS),
              const SizedBox(height: 15),
              SizedBox(width: width * 0.85, child: LogoutButton()),
              const SizedBox(height: 15),
              SizedBox(
                width: width * 0.85,
                child: const Text(
                  SettingsOptionsStrings.BOTTOM_INFO,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: width * 0.85,
                child: const Text(
                  SettingsOptionsStrings.MAIL_INFO,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: width * 0.85,
                child: const Text(
                  SettingsOptionsStrings.LAST_INFO,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
