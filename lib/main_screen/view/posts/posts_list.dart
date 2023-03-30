import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/home/home.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
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

  String? chooseAvatar(String ownerId, Set<UserToPost> usersToPosts) {
    for (UserToPost user in usersToPosts) {
      if (ownerId == user.id) {
        return user.photo;
      }
    }
    return null;
  }

  static String? chooseNameAndDate(
      String ownerId, Set<UserToPost> usersToPosts, String date) {
    for (UserToPost user in usersToPosts) {
      if (ownerId == user.id) {
        return user.name + "\n" + date.substring(0, 16);
      }
    }
    return "Usunięty użytkownik" + "\n" + date.substring(0, 16);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      buildWhen: (previous, current) => previous.posts != current.posts,
      builder: (context, state) {
        switch (state.status) {
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
                                : Container(
                                    // height: 300,
                                    decoration: BoxDecoration(
                                      color: AppColors.WHITE,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.GREY,
                                            blurRadius: 10,
                                            spreadRadius: 1)
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const SizedBox(width: 15),
                                            SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Avatar(
                                                  photo: chooseAvatar(
                                                      state
                                                          .posts[index].ownerId,
                                                      state.usersToPosts)),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(chooseNameAndDate(
                                                state.posts[index].ownerId,
                                                state.usersToPosts,
                                                state.posts[index]
                                                    .creationDate)!),
                                            Spacer(),
                                            if (appState.isAdmin == true ||
                                                user.id ==
                                                    state.posts[index].ownerId)
                                              EditButton(post: state.posts[index]),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const SizedBox(width: 15),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: SizedBox(
                                                  width: width * 0.86,
                                                  child: Text(state.posts[index]
                                                      .postContent)),
                                            )
                                          ],
                                        ),
                                        if (state.posts[index]!.postPhotos
                                                ?.length !=
                                            0)
                                          SizedBox(height: 15),
                                        if (state.posts[index]!.postPhotos
                                                ?.length !=
                                            0)
                                          SizedBox(
                                            height: 10,
                                          ),
                                        if (state.posts[index]!.postPhotos
                                                ?.length !=
                                            0)
                                          Container(
                                              height: 300,
                                              child: ListView.separated(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  // physics: const NeverScrollableScrollPhysics(),
                                                  separatorBuilder:
                                                      (context, ind) =>
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                  shrinkWrap: true,
                                                  itemCount: state.posts[index]
                                                      .postPhotos!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int indexex) {
                                                    return Container(
                                                      // height: 60,
                                                      child: Image(
                                                          image: NetworkImage(state
                                                                  .posts[index]
                                                                  .postPhotos![
                                                              indexex])),
                                                    );
                                                  })),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text("Komentarze: " + state.posts[index].numberOfComments.toString()),
                                            const SizedBox(width: 15),
                                          ],
                                        ),

                                        const SizedBox(height: 20),
                                      ],
                                    ));
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
