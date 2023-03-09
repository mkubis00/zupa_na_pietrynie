import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/main_page/bloc/main_page_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../../home/widgets/avatar.dart';

class MainPageForm extends StatefulWidget {
  const MainPageForm({Key? key}) : super(key: key);

  @override
  State<MainPageForm> createState() => _MainPageFormState();
}

class _MainPageFormState extends State<MainPageForm> {
  final _newPostKey = GlobalKey();
  final _mainPageKey = GlobalKey();

  bool isActionButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocListener<MainPageBloc, MainPageState>(
        listener: (context, state) {},
        child: Scaffold(
            floatingActionButton: !isActionButtonPressed!
                ? FloatingActionButton(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    onPressed: () {
                      isActionButtonPressed
                          ? isActionButtonPressed = false
                          : isActionButtonPressed = true;
                      setState(() {});
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
            body: Stack(
              children: [
                AbsorbPointer(
                    absorbing: isActionButtonPressed,
                    child: Container(
                        key: _mainPageKey,
                        // width: width,
                        // height: height,
                        child: Align(
                          alignment: AlignmentDirectional.center,
                          child: Text("Duppaa"),
                        ))),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Visibility(
                    visible: isActionButtonPressed,
                    child: Container(
                      key: _newPostKey,
                      width: width * 0.95,
                      height: height,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 25,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          )),
                      child: Stack(children: [
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(width: 8),
                                SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          isActionButtonPressed
                                              ? isActionButtonPressed = false
                                              : isActionButtonPressed = true;
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          elevation: 0.0,
                                          shadowColor: Colors.white,
                                        ),
                                        child: Text(
                                          "Anuluj",
                                          style: TextStyle(color: Colors.black),
                                        ))),
                                Spacer(),
                                Text("Utwórz post"),
                                Spacer(),
                                SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      key: const Key('loginForm_googleLogin_'),
                                      child: const Text(
                                        'Opublikuj',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor: Colors.black),
                                      onPressed: () {},
                                    )),
                                SizedBox(width: 10),
                              ],
                            ),
                            _NewPostFormContent(),
                            Expanded(child: _NewPostPhotos()),
                            SizedBox(height: 40),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 15.0,
                                      offset: Offset(0.0, 0.1))
                                ],
                              ),
                              height: 40,
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: TextButton(
                                    key: const Key(
                                        'loginForm_googleLogin_raisedButton'),
                                    child: const Text(
                                      'Wybierz zdjęcia',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white),
                                    onPressed: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        allowMultiple: true,
                                        type: FileType.any,
                                      );
                                      if (result != null) {
                                        List<File?> files = result.paths
                                            .map((path) => File(path!))
                                            .toList();
                                        context
                                            .read<MainPageBloc>()
                                            .add(PostAddPhotosChanged(files));
                                      }
                                    },
                                  )),
                                  SizedBox(width: 10)
                                ],
                              )),
                        )
                      ]),
                    ),
                  ),
                )
              ],
            )));
  }
}

class _NewPostFormContent extends StatefulWidget {
  const _NewPostFormContent({Key? key}) : super(key: key);

  @override
  State<_NewPostFormContent> createState() => _NewPostFormStateContent();
}

class _NewPostFormStateContent extends State<_NewPostFormContent> {
  @override
  Widget build(BuildContext context) {
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    double width = MediaQuery.of(context).size.width;
    return BlocListener<MainPageBloc, MainPageState>(
      listener: (context, state) {},
      child: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
              width: width * 0.87,
              child: Row(
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: Avatar(photo: user.photo),
                  ),
                  SizedBox(width: 20),
                  Text(user.name!),
                ],
              )),
          SizedBox(height: 20),
          SizedBox(
              width: width * 0.87,
              child: TextFormField(
                // initialValue: getNewPostContent(),
                // onChanged: (content) =>
                //     newpostContentChanged(content),
                cursorColor: Colors.black,
                maxLines: 12,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: UnderlineInputBorder(),
                  hintText: 'Dodaj treść posta',
                ),
              )),
          SizedBox(height: 20),
        ],
      )),
    );
  }
}

class _NewPostPhotos extends StatefulWidget {
  const _NewPostPhotos({Key? key}) : super(key: key);

  @override
  State<_NewPostPhotos> createState() => _NewPostPhotosState();
}

class _NewPostPhotosState extends State<_NewPostPhotos> {
  String makePhotoShortName(String longName) {
    int index = longName.lastIndexOf("/");
    return longName.substring(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageBloc, MainPageState>(
        buildWhen: (previous, current) =>
            previous.newPostPhotos != current.newPostPhotos,
        builder: (BuildContext context, state) {
          return ListView.builder(
            itemCount: state.newPostPhotos.length,
            itemBuilder: (context, index) {
              final String? item = state.newPostPhotos[index]?.path;
              return ListTile(
                title: Text(makePhotoShortName(item!)!),
                trailing: ElevatedButton(
                  onPressed: () {
                    context
                        .read<MainPageBloc>()
                        .add(PostAddPhotoDeleted(index));
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    shadowColor: Colors.white,
                  ),
                  child: Icon(
                    IconData(0xe1ba, fontFamily: 'MaterialIcons'),
                    color: Colors.red,
                  ),
                ),
                visualDensity: VisualDensity(vertical: -4),
              );
            },
          );
        });
  }
}
