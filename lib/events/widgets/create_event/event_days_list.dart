import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class EventDaysList extends StatelessWidget {
  const EventDaysList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
        previous.newEventDays != current.newEventDays,
        builder: (context, state) {
          return ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context,
                  int index) => const Divider(color: AppColors.BLACK,),
              itemCount: state.newEventDays.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleEventDay(
                  key: UniqueKey(),
                    eventDay: state.newEventDays[index]);
                  // ListTile(
                  // key: UniqueKey(),
                  // title: Text(state.newEventDays[index].dayOfEvent, style: TextStyle(fontWeight: FontWeight.w600,),),
                  // trailing: IconButton(
                  //   icon: const Icon(
                  //     IconData(
                  //       0xe1b9,
                  //       fontFamily: 'MaterialIcons',
                  //     ),
                  //     color: AppColors.RED,
                  //   ),
                  //   // the method which is called
                  //   // when button is pressed
                  //   onPressed: () {
                  //     context.read<EventsBloc>().add(DeleteNewEventDay(state.newEventDays[index]));
                  //   },
                  // ),
                  // subtitle: EventDayElements(eventDay: state.newEventDays[index]),
                // );
              });
        });
  }
}
