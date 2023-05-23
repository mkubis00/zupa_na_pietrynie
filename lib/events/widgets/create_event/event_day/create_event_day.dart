import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/events/widgets/create_event/event_day/add_event_day_button.dart';

class CreateEventDay extends StatelessWidget {
  const CreateEventDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EventDayPicker(),
        const SizedBox(height: 20),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsetsDirectional.only(start: 10),
                child: Text(
                  "Stwórz elementy wydarzenia w dniu",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ))),
        const SizedBox(height: 20),
        EventElementHourPicker(),
        EventElementTitleInput(),
        AddEventElementToNewEventDayButton(),
        const SizedBox(height: 20),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsetsDirectional.only(start: 10),
                child: Text(
                  "Elementy dodane do dnia:",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ))),
        const SizedBox(height: 20),
        EventElementsList(),
        const SizedBox(height: 20),
        AddEventDayButton(),
      ],
    );
  }
}
