import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

import '../../app/bloc/app_bloc.dart';

class EventsForm extends StatefulWidget {
  const EventsForm({Key? key}) : super(key: key);

  @override
  State<EventsForm> createState() => _EventsFormState();
}

class _EventsFormState extends State<EventsForm> {
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
    // if (_isBottom) context.read<MainScreenBloc>().add(PostsFetch(false));
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = context.read<AppBloc>().state.isAdmin;
    return BlocListener<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state.eventElementChangeStatus.isSubmissionFailure) {
            snackBarWarning(
                context, "Wystąpil blad w trakcie zapisu do wydarzenia");
          }
        },
        child: Scaffold(
            floatingActionButton: isAdmin ? FloatingActionButton(
                foregroundColor: AppColors.WHITE,
                backgroundColor: AppColors.BLACK,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateEventForm()),
                  );
                },
                child: const Icon(Icons.add)) : null,
            body: Container(
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: RefreshIndicator(
                      color: AppColors.BLACK,
                      onRefresh: () async {
                        context.read<EventsBloc>().add(EventsFetch());
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            Padding(padding: EdgeInsetsDirectional.only(start: 10, end: 10), child:
                            EventsListController()),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )),
                ))));
  }
}
