import 'package:events_repository/events_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../content_holder/src/colors/colors.dart';
import '../../bloc/events_bloc.dart';

class EventDayElements extends StatelessWidget {
  const EventDayElements({Key? key, required EventDay this.eventDay})
      : super(key: key);

  final EventDay eventDay;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
    previous.newEventDays != current.newEventDays,
    builder: (context, state) {

    return Container(
      height: 200,
      child: ListView.builder(
          itemCount: eventDay.eventElements.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            key: UniqueKey(),
            title: Text(eventDay.eventElements[index].hour + " - " + eventDay.eventElements[index].title, style: TextStyle(fontSize: 15),),
          );
        }
      )
    );});
  }
}
