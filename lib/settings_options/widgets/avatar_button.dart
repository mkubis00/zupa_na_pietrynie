import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/home/home.dart';
import 'package:zupa_na_pietrynie/settings_options/settings_options.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingOptionsCubit, SettingOptionsState>(
        buildWhen: (previous, current) =>
        previous.photoStatus != current.photoStatus,
        builder: (context, state) {
          return state.photoStatus.name == "photoUpdateInProgress"
              ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: AppColors.BLACK))
              : MaterialButton(
            onLongPress: () =>
                context.read<SettingOptionsCubit>().updateUserPhoto(),
            onPressed: () {},
            child: Align(
              alignment: Alignment.topCenter,
              child: Avatar(photo: user.photo),
            ),
          );
        });
  }

  AvatarButton(this.user);

  final User user;
}