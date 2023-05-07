import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';
import 'package:posts_repository/posts_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class PostsList extends StatefulWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final bool isAdmin = context.read<AppBloc>().state.isAdmin;
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      buildWhen: (previous, current) => previous.posts != current.posts,
      builder: (context, state) {
        switch (state.postsFetchStatus) {
          case FormzStatus.submissionSuccess:
            return Container(
                width: width * 0.95,
                child: ListView.separated(
                    key: UniqueKey(),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(state.posts.length);
                      Post post = state.posts[index];
                      return index >= state.posts.length
                          ? const BottomLoader()
                          : SinglePost(
                              post: post,
                              usersToPosts: state.usersToPosts,
                              isAdmin: isAdmin,
                              key: UniqueKey());
                    }));
          default:
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.BLACK,
            ));
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
