import 'package:flutter/material.dart';

import 'package:events_repository/events_repository.dart';

import 'package:zupa_na_pietrynie/events/events.dart';

class EventDaysList extends StatelessWidget {
  const EventDaysList({Key? key, required this.eventDays}) : super(key: key);

  final List<EventDay> eventDays;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: eventDays.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: 15, end: 10, bottom: 7),
                        child: Text(
                          eventDays[index].dayOfEvent + " :",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )),
                    EventElementList(eventElements: eventDays[index].eventElements),
                    const SizedBox(height: 10),
                  ]));
        });
  }
}
