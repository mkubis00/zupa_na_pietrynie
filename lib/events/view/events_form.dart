import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';

import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';

class EventsForm extends StatefulWidget {
  const EventsForm({Key? key}) : super(key: key);

  @override
  State<EventsForm> createState() => _EventsFormState();
}

class _EventsFormState extends State<EventsForm> {
  @override
  Widget build(BuildContext context) {
    final bool isAdmin = context.read<AppBloc>().state.isAdmin;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state.eventElementChangeStatus.isSubmissionFailure) {
            snackBarWarning(context, EventsStrings.SIGH_TO_EVENT_ERROR);
          } else if (state.eventDeletedStatus.isSubmissionSuccess) {
            snackBarSuccess(context, EventsStrings.EVENT_DELETED);
          } else if (state.eventDeletedStatus.isSubmissionFailure) {
            snackBarWarning(context, EventsStrings.UNABLE_TO_DELETE_EVENT);
          } else if (state.newEventStatus.isSubmissionSuccess) {
            snackBarSuccess(context, EventsStrings.NEW_EVENT_ADDED);
          } else if (state.newEventStatus.isSubmissionFailure) {
            snackBarWarning(context, EventsStrings.UNABLE_TO_ADD_EVENT);
          }
        },
        child: Scaffold(
            floatingActionButton: isAdmin
                ? FloatingActionButton(
                    foregroundColor: AppColors.WHITE,
                    backgroundColor: AppColors.GREEN,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateEventForm()),
                      );
                    },
                    child: const Icon(Icons.add))
                : null,
            body: Container(
                color: AppColors.BACKGROUND_COLOR,
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: RefreshIndicator(
                      color: AppColors.BLACK,
                      onRefresh: () async {
                        context.read<EventsBloc>().add(EventsFetchEvent());
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: width * 0.07),
                                  child: const Text(EventsStrings.CURRENT_WEEK,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19)),
                                )),
                            const SizedBox(height: 25),
                            Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: width * 0.05, end: width * 0.05),
                                child: Calendar()),
                            const SizedBox(height: 25),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: width * 0.07),
                                  child: const Text(EventsStrings.EVENTS,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19)),
                                )),
                            const SizedBox(height: 25),
                            Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: width * 0.05, end: width * 0.05),
                                child: EventsListController()),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )),
                ))));
  }
}
