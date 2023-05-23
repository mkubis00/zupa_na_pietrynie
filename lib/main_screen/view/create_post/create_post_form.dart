import 'package:flutter/material.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class CreatePostRoute extends StatelessWidget {
  const CreatePostRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        bottomSheet: ChoosePhotosButton(),
        appBar: AppBar(
          title: const Text(
            MainScreenStrings.CREATE_POST,
            style: TextStyle(color: AppColors.BLACK),
          ),
          backgroundColor: AppColors.BACKGROUND_COLOR,
          shadowColor: AppColors.BACKGROUND_COLOR,
          elevation: 0,
          leading: BackButton(
            color: AppColors.GREEN,
          ),
          actions: <Widget>[CreatePostButton()],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 50),
            ContentInput(),
            const SizedBox(height: 10),
            PhotosList(),
          ],
        )));
  }
}
