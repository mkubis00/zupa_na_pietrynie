import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class EventsList extends StatelessWidget {
  const EventsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) => previous.events != current.events,
        builder: (context, state) {
          return SingleChildScrollView(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                key: UniqueKey(),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  return SingleEvent(
                      key: UniqueKey(), event: state.events[index]);
                }),
          );
        });
  }
}
