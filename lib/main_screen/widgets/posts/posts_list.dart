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
    if (_isBottom) context.read<MainScreenBloc>().add(PostsFetch(false));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void test() async {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final bool isAdmin = context.read<AppBloc>().state.isAdmin;
     return BlocBuilder<MainScreenBloc, MainScreenState>(
      buildWhen: (previous, current) => previous.posts != current.posts,
      builder: (context, state) {
        switch (state.postsStatus) {
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case PostStatus.success:
                  return
                    Container(
                      width: width * 0.95,
                      child: ListView.separated(
                        key: UniqueKey(),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 20,
                              ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            Post post = state.posts[index];
                            return index >= state.posts.length
                                ? const BottomLoader()
                                : SinglePost(post: post, usersToPosts: state.usersToPosts, isAdmin: isAdmin, key: UniqueKey(),);
                          }));
          case PostStatus.empty:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );

}}

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
