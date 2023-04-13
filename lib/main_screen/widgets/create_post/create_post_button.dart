import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class CreatePostButton extends StatelessWidget {
  const CreatePostButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
        buildWhen: (previous, current) =>
            previous.newPostContent != current.newPostContent,
        builder: (context, state) {
          return Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 5),
              child: ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text(
                  MainScreenStrings.PUBLISH,
                  style: const TextStyle(color: AppColors.WHITE),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.BLACK),
                onPressed: state.newPostContent.length > 10
                    ? () {
                        context.read<MainScreenBloc>().add(PostCreate());
                        Navigator.pop(context);
                      }
                    : null,
              ));
        });
  }
}
