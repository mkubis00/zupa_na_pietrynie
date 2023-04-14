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
            setState(() {});
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
          } else if (state.newCommentStatus.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Dodano nowy komenatrz"),
                ),
              );
          }else if (state.postUpdateStatus.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Zaktualizowano post"),
                ),
              );
          } else if (state.postUpdateStatus.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Nie udalo się zaktualizować postu"),
                ),
              );
          } else if (state.commentsStatus.name == "failure") {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Nie udalo sie pobrać komentarzy"),
                ),
              );
          } else if (state.postDeleteStatus.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Nie udalo sie usunąć posta"),
                ),
              );
          } else if (state.postDeleteStatus.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Usunięto post"),
                ),
              );
          } else if (state.newCommentStatus.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Nie udalo się dodać komentarza"),
                ),
              );
          } else if (state.commentDeleteStatus.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Usunięto komenatrz"),
                ),
              );
          } else if (state.commentDeleteStatus.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Nie udalo się usunąć komentarza"),
                ),
              );
          }
        },
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
                foregroundColor: AppColors.WHITE,
                backgroundColor: AppColors.BLACK,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreatePostRoute()),
                  );
                },
                child: const Icon(Icons.add)),
            body: Container(
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
                        PostsList(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )),
            ))));
  }
}
