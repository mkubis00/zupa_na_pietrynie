import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/events_bloc.dart';

class EventDayPicker extends StatelessWidget {
  const EventDayPicker({Key? key}) : super(key: key);

  static String getDayWeekName(int i) {
    switch (i) {
      case 1:
        return 'Poniedzialek';
      case 2:
        return 'Wtorek';
      case 3:
        return 'Środa';
      case 4:
        return 'Czwartek';
      case 5:
        return 'Piątek';
      case 6:
        return 'Sobota';
      case 7:
        return 'Niedziela';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.eventDayToCreate.dayOfEvent != current.eventDayToCreate.dayOfEvent,
        builder: (context, state) {
          DateTime now = DateTime.now();
          return SizedBox(
              height: 80,
              child: CupertinoDatePicker(
                key: UniqueKey(),
                mode: CupertinoDatePickerMode.date,
                initialDateTime: state.eventDayToCreate.dayOfEvent != ''
                    ? DateFormat('dd/MM/yy hh:mm').parse(
                        state.eventDayToCreate.dayOfEvent.substring(0, 8) +
                            " 23:59")
                    : DateTime.now(),
                minimumDate: now,
                onDateTimeChanged: (DateTime newDateTime) {
                  String formattedDate =
                      DateFormat('dd/MM/yy').format(newDateTime!) +
                          " - " +
                          getDayWeekName(newDateTime.weekday);
                  context
                      .read<EventsBloc>()
                      .add(NewEventDayChangeEvent(formattedDate));
                },
              ));
        });
  }
}
