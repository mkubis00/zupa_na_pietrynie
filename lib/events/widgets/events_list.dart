import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';
import 'package:posts_repository/posts_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class EventsList extends StatefulWidget {
  const EventsList({Key? key}) : super(key: key);

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final bool isAdmin = context.read<AppBloc>().state.isAdmin;
    return BlocBuilder<EventsBloc, EventsState>(
      buildWhen: (previous, current) => previous.eventsStatus != current.eventsStatus,
      builder: (context, state) {
        print(state.events.length);
        switch (state.eventsStatus) {
          case FormzStatus.submissionSuccess:
            return
              Container(
                width: width * 0.95,
                child: ListView.separated(
                    key: UniqueKey(),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.events.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(state.events.length);
                      // Event post = state.events[index];
                      return index >= state.events.length
                          ? const BottomLoader()
                          :
                      // SinglePost(
                      //     post: post,
                      //     usersToPosts: state.usersToPosts,
                      //     isAdmin: isAdmin,
                      //     key: UniqueKey());
                      Text("DADADA", key: UniqueKey(),);
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

class PostsList1 extends StatefulWidget {
  const PostsList1({Key? key}) : super(key: key);

  @override
  State<PostsList1> createState() => _PostsList1State();
}

class _PostsList1State extends State<PostsList1> {
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