import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/events_bloc.dart';

class EventElementHourPicker extends StatelessWidget {
  const EventElementHourPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.newEventElementHour != current.newEventElementHour,
        builder: (context, state) {
          return SizedBox(
            height: 38,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: state.newEventElementHour != '' ? DateFormat('HH:mm').parse(state.newEventElementHour) : null,
                onDateTimeChanged: (DateTime value) {
                  String formattedHour = DateFormat('HH:mm').format(value!);
                  context
                      .read<EventsBloc>()
                      .add(NewEventElementHourChangeEvent(formattedHour));
                }),
          );
        });
  }
}
