import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/main_screen/widgets/posts/posts_list.dart';

class PostsListController extends StatefulWidget {
  const PostsListController({Key? key}) : super(key: key);

  @override
  State<PostsListController> createState() => _PostsListControllerState();
}

class _PostsListControllerState extends State<PostsListController> {
  final _scrollController = ScrollController();

  late final StreamSubscription<void> subscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    subscription = context.read<MainScreenBloc>().widgetStateUpdate.listen((event) {
      setState(() {});
    });
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
    return PostsList();
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
