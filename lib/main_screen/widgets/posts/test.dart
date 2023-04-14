import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/main_screen/widgets/posts/posts_list.dart';
import 'package:zupa_na_pietrynie/main_screen/widgets/posts/single_post.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../bloc/main_screen_bloc.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final bool isAdmin = context.read<AppBloc>().state.isAdmin;
    final int le = context.read<MainScreenBloc>().state.posts.length;
    setState(() {});
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      buildWhen: (previous, current) => previous.posts != current.posts,
      builder: (context, state) {
        switch (state.postsFetchStatus) {
          case FormzStatus.submissionFailure:
            return const Center(child: Text('failed to fetch posts'));
          case FormzStatus.submissionSuccess:
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
          default:
            return const Center(child: CircularProgressIndicator(color: AppColors.BLACK,));
        }
      },
    );
  }
}
