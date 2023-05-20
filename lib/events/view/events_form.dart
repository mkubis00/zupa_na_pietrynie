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
    double width = MediaQuery.of(context).size.width;
    return BlocListener<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state.eventElementChangeStatus.isSubmissionFailure) {
            snackBarWarning(
                context, "Wystąpil blad w trakcie zapisu do wydarzenia");
          } else if (state.eventDeleted.isSubmissionSuccess) {
            snackBarSuccess(
                context, "Usunięto wydarzenie");
          } else if (state.eventDeleted.isSubmissionFailure) {
            snackBarWarning(
                context, "Nie usunięto wydarzenia, wystąpil blad");
          } else if (state.newEventStatus.isSubmissionSuccess) {
            snackBarSuccess(
                context, "Dodano wydarzenie");
          } else if (state.newEventStatus.isSubmissionFailure) {
            snackBarWarning(
                context, "Nie udalo się dodać wydarzenia");
          }
        },
        child: Scaffold(
            floatingActionButton: isAdmin ? FloatingActionButton(
                foregroundColor: AppColors.WHITE,
              backgroundColor: AppColors.GREEN,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateEventForm()),
                  );
                },
                child: const Icon(Icons.add)) : null,
            body: Container(
                color: AppColors.BACKGROUND_COLOR,
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: RefreshIndicator(
                      color: AppColors.BLACK,
                      onRefresh: () async {
                        context.read<EventsBloc>().add(EventsFetch());
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Padding(
                                  padding: EdgeInsetsDirectional.only(start: width * 0.07),
                                  child:
                                  const Text("Obecny tydzień",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19
                                      )),
                                )),
                            const SizedBox(height: 25),
                        Padding(padding: EdgeInsetsDirectional.only(start: width * 0.05, end: width * 0.05), child:Calendar()),
                            const SizedBox(height: 25),
                         Align(
                          alignment: Alignment.centerLeft,
                          child:
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: width * 0.07),
                            child:
                          const Text("Wydarzenia",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19
                              )),
                        )),
                            const SizedBox(height: 25),
                            Padding(padding: EdgeInsetsDirectional.only(start: width * 0.05, end: width * 0.05), child:
                            EventsListController()),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )),
                ))));
  }
}
