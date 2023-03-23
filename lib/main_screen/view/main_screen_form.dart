import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class MainScreenForm extends StatefulWidget {
  const MainScreenForm({Key? key}) : super(key: key);

  @override
  State<MainScreenForm> createState() => _MainScreenFormState();
}

class _MainScreenFormState extends State<MainScreenForm> {
  bool isActionButtonPressed = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) context.read<MainScreenBloc>().add(PostFetched(false));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocListener<MainScreenBloc, MainScreenState>(
        listener: (context, state) {
          if (state.newPostStatus.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content:
                      const Text(MainScreenStrings.SNACK_BAR_NEW_POST_ADDED),
                ),
              );

          } else if (state.newPostStatus.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(MainScreenStrings.SNACK_BAR_NEW_POST_FAILED +
                      state.errorMessage!),
                ),
              );
          } else if (state.newPostStatus.isSubmissionInProgress) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(MainScreenStrings.SNACK_BAR_NEW_POST_ADDING),
                ),
              );
          }
        },
        child: Scaffold(
            floatingActionButton: !isActionButtonPressed!
                ? FloatingActionButton(
                    foregroundColor: AppColors.WHITE,
                    backgroundColor: AppColors.BLACK,
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
                        child: Align(

                      alignment: AlignmentDirectional.topCenter,
                      child: RefreshIndicator(
                      onRefresh: () async{
                        context.read<MainScreenBloc>().add(PostFetched(true));
                        },
                      child:
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                             EventsCounterForm(),


                            /////////////////////////////////////////////////////////////////////////////////
                            const SizedBox(height: 20),
                            // ElevatedButton(onPressed: () {
                            //   context.read<MainScreenBloc>().add(PostFetched(true));
                            // }, child: Text("Gbhg")),
                            // const SizedBox(height: 20),
                            // Container(
                            //     height: 320,
                            //     width: width * 0.93,
                            //     decoration: BoxDecoration(
                            //       color: AppColors.GREY,
                            //       borderRadius: BorderRadius.circular(20),
                            //       boxShadow: [
                            //         BoxShadow(
                            //             color: AppColors.GREY,
                            //             blurRadius: 5,
                            //             spreadRadius: 1)
                            //       ],
                            //     ),
                            //     child: Align(
                            //       alignment: Alignment.center,
                            //       child: SizedBox(
                            //         width: 30,
                            //         height: 30,
                            //         child: CircularProgressIndicator(color: AppColors.BLACK),
                            //       ),
                            //     )),
                            // const SizedBox(height: 15),
                            // Container(
                            //     height: 320,
                            //     width: width * 0.93,
                            //     decoration: BoxDecoration(
                            //       color: AppColors.GREY,
                            //       borderRadius: BorderRadius.circular(20),
                            //       boxShadow: [
                            //         BoxShadow(
                            //             color: AppColors.GREY,
                            //             blurRadius: 5,
                            //             spreadRadius: 1)
                            //       ],
                            //     ),
                            //     child: Align(
                            //       alignment: Alignment.center,
                            //       child: SizedBox(
                            //         width: 30,
                            //         height: 30,
                            //         child: CircularProgressIndicator(color: AppColors.BLACK),
                            //       ),
                            //     )),

                            PostsList(),
                            const SizedBox(height: 10),
                            /////////////////////////////////////////////////////////////////////////////////
                          ],
                        ),
                      )),
                    ))),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Visibility(
                    visible: isActionButtonPressed,
                    child: Container(
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
                          color: AppColors.WHITE,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          )),
                      child: Stack(children: [
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const SizedBox(width: 8),
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
                                          backgroundColor: AppColors.WHITE,
                                          elevation: 0.0,
                                          shadowColor: AppColors.WHITE,
                                        ),
                                        child: const Text(
                                          MainScreenStrings.CANCEL,
                                          style: const TextStyle(
                                              color: AppColors.BLACK),
                                        ))),
                                Spacer(),
                                const Text(MainScreenStrings.CREATE_POST),
                                Spacer(),
                                SizedBox(
                                    width: 100,
                                    child: BlocBuilder<MainScreenBloc,
                                            MainScreenState>(
                                        buildWhen: (previous, current) =>
                                            previous.newPostContent !=
                                            current.newPostContent,
                                        builder: (context, state) {
                                          return ElevatedButton(
                                            key: const Key(
                                                'loginForm_continue_raisedButton'),
                                            child: const Text(
                                              MainScreenStrings.PUBLISH,
                                              style: const TextStyle(
                                                  color: AppColors.WHITE),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor: AppColors.BLACK),
                                            onPressed: state
                                                        .newPostContent.length >
                                                    10
                                                ? () {
                                                    context
                                                        .read<MainScreenBloc>()
                                                        .add(PostAdd());
                                                    isActionButtonPressed
                                                        ? isActionButtonPressed =
                                                            false
                                                        : isActionButtonPressed =
                                                            true;
                                                    setState(() {});
                                                  }
                                                : null,
                                          );
                                        })),
                                const SizedBox(width: 10),
                              ],
                            ),
                            NewPostForm(),
                            Expanded(child: NewPostPhotos()),
                            const SizedBox(height: 40),
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
                                color: AppColors.WHITE,
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
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: TextButton(
                                    key: const Key(
                                        'loginForm_googleLogin_raisedButton'),
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
                                        List<File?> files = result.paths
                                            .map((path) => File(path!))
                                            .toList();
                                        context
                                            .read<MainScreenBloc>()
                                            .add(PostAddPhotosChanged(files));
                                      }
                                    },
                                  )),
                                  const SizedBox(width: 10)
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
