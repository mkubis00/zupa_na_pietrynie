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
    if (_isBottom) context.read<MainScreenBloc>().add(PostsFetch(false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainScreenBloc, MainScreenState>(
        listener: (context, state) {
          if (state.newPostStatus.isSubmissionSuccess) {
            snackBarSuccess(
                context, MainScreenStrings.SNACK_BAR_NEW_POST_ADDED);
          } else if (state.newPostStatus.isSubmissionFailure) {
            snackBarWarning(
                context, MainScreenStrings.SNACK_BAR_NEW_POST_FAILED);
          } else if (state.newPostStatus.isSubmissionInProgress) {
            snackBarInfo(context, MainScreenStrings.SNACK_BAR_NEW_POST_ADDING);
          } else if (state.newCommentStatus.isSubmissionSuccess) {
            snackBarSuccess(context, MainScreenStrings.SNACK_BAR_NEW_COMMENT_ADDED);
          } else if (state.postUpdateStatus.isSubmissionSuccess) {
            snackBarInfo(context, MainScreenStrings.SNACK_BAR_POST_UPDATED);
          } else if (state.postUpdateStatus.isSubmissionFailure) {
            snackBarWarning(context, MainScreenStrings.SNACK_BAR_POST_UPDATE_FAILURE);
          } else if (state.commentsStatus.isSubmissionFailure) {
            snackBarWarning(context, MainScreenStrings.SNACK_BAR_COMMENTS_FETCH_FAILURE);
          } else if (state.postDeleteStatus.isSubmissionFailure) {
            snackBarWarning(context, MainScreenStrings.SNACK_BAR_POST_DELETE_FAILURE);
          } else if (state.postDeleteStatus.isSubmissionSuccess) {
            snackBarInfo(context, MainScreenStrings.SNACK_BAR_POST_DELETED);
          } else if (state.newCommentStatus.isSubmissionFailure) {
            snackBarWarning(context, MainScreenStrings.SNACK_BAR_COMMENT_ADD_FAILURE);
          } else if (state.commentDeleteStatus.isSubmissionSuccess) {
            snackBarInfo(context, MainScreenStrings.SNACK_BAR_COMMENT_DELETED);
          } else if (state.commentDeleteStatus.isSubmissionFailure) {
            snackBarWarning(context, MainScreenStrings.SNACK_BAR_COMMENT_DELETE_FAILURE);
          }
        },
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
                foregroundColor: AppColors.WHITE,
                backgroundColor: AppColors.GREEN,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreatePostRoute()),
                  );
                },
                child: const Icon(Icons.add)),
            body: Container(
                color: AppColors.BACKGROUND_COLOR,
                child: Align(
              alignment: AlignmentDirectional.topCenter,
              child: RefreshIndicator(
                  color: AppColors.BLACK,
                  onRefresh: () async {
                    context.read<MainScreenBloc>().add(PostsFetch(true));
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        EventsCounter(),
                        const SizedBox(height: 20),
                        PostsListController(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )),
            ))));
  }
}
