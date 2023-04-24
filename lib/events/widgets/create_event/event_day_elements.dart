import 'package:events_repository/events_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

import '../../../content_holder/src/colors/colors.dart';

class EventDayElements extends StatelessWidget {
  const EventDayElements({Key? key, required EventDay this.eventDay})
      : super(key: key);

  final EventDay eventDay;

  @override
  Widget build(BuildContext context) {
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
                      title: Text(
                        eventDay.eventElements[index].hour +
                            " - " +
                            eventDay.eventElements[index].title,
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          IconData(
                            0xe1b9,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: AppColors.RED,
                        ),
                        // the method which is called
                        // when button is pressed
                        onPressed: () {
                          context.read<EventsBloc>().add(DeleteNewEventElement(eventDay, eventDay.eventElements[index]));
                        },
                      ),
                    );
                  }));
        });
  }
}
