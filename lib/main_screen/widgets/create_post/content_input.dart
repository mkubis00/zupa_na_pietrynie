import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class ContentInput extends StatefulWidget {
  const ContentInput({Key? key}) : super(key: key);

  @override
  State<ContentInput> createState() => _ContentInputState();
}

class _ContentInputState extends State<ContentInput> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
        height: height * 0.53,
        child: TextFormField(
          initialValue: context.read<MainScreenBloc>().state.newPostContent,
          onChanged: (content) =>
              context.read<MainScreenBloc>().add(NewPostContentChange(content)),
          cursorColor: AppColors.BLACK,
          maxLines: 70,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.BLACK),
            ),
            border: UnderlineInputBorder(),
            hintText: MainScreenStrings.ADD_NEW_POST_CONTENT,
            contentPadding: EdgeInsets.all(10.0),
          ),
        ));
  }
}
