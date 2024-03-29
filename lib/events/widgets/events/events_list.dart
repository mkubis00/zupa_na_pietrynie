import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:events_repository/events_repository.dart';

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
      buildWhen: (previous, current) =>
          previous.eventsStatus != current.eventsStatus,
      builder: (context, state) {
        switch (state.eventsStatus) {
          case FormzStatus.submissionSuccess:
            if (state.events.length == 0) {
              return Padding(
                padding: EdgeInsetsDirectional.only(top: 150),
                child: SizedBox(
                    width: width * 0.8,
                    child: Text(
                      EventsStrings.EVENT_LIST_EMPTY,
                      textAlign: TextAlign.center,
                    )),
              );
            } else {
              return Container(
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
                        Event post = state.events[index];
                        return index >= state.events.length
                            ? const _BottomLoader()
                            : SingleEvent(
                                event: post,
                                isAdmin: isAdmin,
                                key: UniqueKey());
                      }));
            }
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

class _BottomLoader extends StatelessWidget {
  const _BottomLoader({super.key});

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
