import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

import '../../bloc/main_screen_bloc.dart';

import 'dart:io';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class CreatePostRoute extends StatelessWidget {
  const CreatePostRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomSheet: Container(
            decoration: BoxDecoration(
              color: AppColors.WHITE,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.1))
              ],
            ),
            height: height * 0.07,
            child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    width: width,
                    child: TextButton(
                      key: const Key('loginForm_googleLogin_raisedButton'),
                      child: const Text(
                        MainScreenStrings.CHOOSE_PHOTOS,
                        style: TextStyle(color: AppColors.BLACK),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.WHITE),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.any,
                        );
                        if (result != null) {
                          List<File?> files =
                              result.paths.map((path) => File(path!)).toList();
                          context
                              .read<MainScreenBloc>()
                              .add(PostAddPhotosChanged(files));
                        }
                      },
                    )))),
        appBar: AppBar(
          title: const Text(
            'Opublikuj post',
            style: TextStyle(color: AppColors.BLACK),
          ),
          backgroundColor: AppColors.WHITE,
          shadowColor: AppColors.WHITE,
          elevation: 0,
          leading: BackButton(
            color: AppColors.BLACK,
          ),
          actions: <Widget>[
            BlocBuilder<MainScreenBloc, MainScreenState>(
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
                                context.read<MainScreenBloc>().add(PostAdd());
                                Navigator.pop(context);
                              }
                            : null,
                      ));
                })
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            SizedBox(
                height: height * 0.53,
                child: TextFormField(
                  initialValue:
                      context.read<MainScreenBloc>().state.newPostContent,
                  onChanged: (content) => context
                      .read<MainScreenBloc>()
                      .add(PostAddContentChanged(content)),
                  cursorColor: AppColors.BLACK,
                  maxLines: 100,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.BLACK),
                    ),
                    border: UnderlineInputBorder(),
                    hintText: MainScreenStrings.ADD_NEW_POST_CONTENT,
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                )),
            const SizedBox(height: 10),
            SizedBox(height: height * 0.4, child: NewPostPhotos()),
          ],
        )));
  }
}
