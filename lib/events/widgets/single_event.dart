import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:events_repository/events_repository.dart';

class SingleEvent extends StatelessWidget {
  const SingleEvent({Key? key, required Event this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return
      Container(
    child:
      Row(
      children: [
        Text(event.title),
        Text(event.publishDate),
        Text(event.description),
        // Text(event.eventDays.length as String),
      ],
    ));
  }
}
