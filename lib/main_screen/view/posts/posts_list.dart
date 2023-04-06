import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/app/app.dart';

class PostsList extends StatefulWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
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

  void _onScroll() {
    if (_isBottom) context.read<MainScreenBloc>().add(PostFetched(false));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      buildWhen: (previous, current) => previous.posts != current.posts,
      builder: (context, state) {
        switch (state.postsStatus) {
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case PostStatus.success:
                  return
                    BlocBuilder<AppBloc, AppState>(
                        builder: (context, appState) {
                          return
                    Container(
                      width: width * 0.95,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                                height: 20,
                              ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return index >= state.posts.length
                                ? const BottomLoader()
                                : SinglePost(post: state.posts[index], usersToPosts: state.usersToPosts, isAdmin: appState.isAdmin);
                          }));
                });
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
