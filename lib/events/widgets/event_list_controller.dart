import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/main_screen/widgets/posts/posts_list.dart';

class EventsListController extends StatefulWidget {
  const EventsListController({Key? key}) : super(key: key);

  @override
  State<EventsListController> createState() => _EventsListControllerState();
}

class _EventsListControllerState extends State<EventsListController> {
  final _scrollController = ScrollController();

  late final StreamSubscription<void> subscription;

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
    // subscription = context.read<MainScreenBloc>().widgetStateUpdate.listen((event) {
    //   setState(() {});
    // });
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
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) => previous.events != current.events,
    builder: (context, state) {
    return EventsList(key: UniqueKey());
        });
  }
}

