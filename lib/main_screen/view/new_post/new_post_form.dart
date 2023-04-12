import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:authentication_repository/authentication_repository.dart';

import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/home/home.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({Key? key}) : super(key: key);

  @override
  State<NewPostForm> createState() => NewPostFormState();
}

class NewPostFormState extends State<NewPostForm> {
  @override
  Widget build(BuildContext context) {
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    final double width = MediaQuery.of(context).size.width;
    return BlocListener<MainScreenBloc, MainScreenState>(
      listener: (context, state) {},
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
              width: width * 0.87,
              child: Row(
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: Avatar(photo: user.photo, avatarSize: 38),
                  ),
                  const SizedBox(width: 20),
                  Text(user.name!),
                ],
              )),
          const SizedBox(height: 20),
          SizedBox(
              width: width * 0.87,
              child: TextFormField(
                initialValue:
                    context.read<MainScreenBloc>().state.newPostContent,
                onChanged: (content) => context
                    .read<MainScreenBloc>()
                    .add(PostAddContentChanged(content)),
                cursorColor: AppColors.BLACK,
                maxLines: 12,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.BLACK),
                  ),
                  border: UnderlineInputBorder(),
                  hintText: MainScreenStrings.ADD_NEW_POST_CONTENT,
                ),
              )),
          const SizedBox(height: 20),
        ],
      )),
    );
  }
}
