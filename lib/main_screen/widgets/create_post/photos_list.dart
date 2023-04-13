import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class PhotosList extends StatefulWidget {
  const PhotosList({Key? key}) : super(key: key);

  @override
  State<PhotosList> createState() => PhotosListState();
}

class PhotosListState extends State<PhotosList> {
  static String makePhotoShortName(String longName) {
    int index = longName.lastIndexOf("/");
    return longName.substring(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
        height: height * 0.4,
        child: BlocBuilder<MainScreenBloc, MainScreenState>(
            buildWhen: (previous, current) =>
                previous.newPostPhotos != current.newPostPhotos,
            builder: (BuildContext context, state) {
              return Container(
                  child: ListView.builder(
                itemCount: state.newPostPhotos.length,
                itemBuilder: (context, index) {
                  final String? item = state.newPostPhotos[index]?.path;
                  return ListTile(
                    title: Text(makePhotoShortName(item!)!),
                    trailing: ElevatedButton(
                      onPressed: () {
                        context
                            .read<MainScreenBloc>()
                            .add(NewPostPhotoDelete(index));
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.WHITE,
                        elevation: 0.0,
                        shadowColor: AppColors.BLACK,
                      ),
                      child: const Icon(
                        IconData(0xe1ba, fontFamily: 'MaterialIcons'),
                        color: AppColors.RED,
                      ),
                    ),
                    visualDensity: VisualDensity(vertical: -4),
                  );
                },
              ));
            }));
  }
}
