import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../content_holder/src/colors/colors.dart';
import '../../../bloc/events_bloc.dart';

class EventElementsList extends StatelessWidget {
  const EventElementsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
    previous.eventDayToCreate != current.eventDayToCreate,
    builder: (context, state) {
    return
      state.eventDayToCreate.eventElements.length < 1
        ? Text('Brak')
        : Container(
            height: state.eventDayToCreate.eventElements.length * 60,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    state.eventDayToCreate.eventElements.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    key: UniqueKey(),
                    title: Text(
                      state.eventDayToCreate.eventElements[index]
                              .hour +
                          " - " +
                          state.eventDayToCreate.eventElements[index]
                              .title,
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
                        context.read<EventsBloc>().add(
                            DeleteNewEventElement(state
                                .eventDayToCreate
                                .eventElements[index]));
                      },
                    ),
                  );
                }));});
  }
}
