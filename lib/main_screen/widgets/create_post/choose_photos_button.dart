import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class ChoosePhotosButton extends StatelessWidget {
  const ChoosePhotosButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
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
                  key: const Key('choose_photos_key_button'),
                  child: const Text(
                    MainScreenStrings.CHOOSE_PHOTOS,
                    style: TextStyle(color: AppColors.BLACK),
                  ),
                  style: TextButton.styleFrom(backgroundColor: AppColors.WHITE),
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
                          .add(NewPostPhotosChange(files));
                    }
                  },
                ))));
  }
}
