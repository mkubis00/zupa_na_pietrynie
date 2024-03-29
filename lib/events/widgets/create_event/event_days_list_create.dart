import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../content_holder/src/colors/colors.dart';
import '../../bloc/events_bloc.dart';

class EventDaysListCreate extends StatelessWidget {
  const EventDaysListCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.newEventDays != current.newEventDays,
        builder: (context, state) {
          return Column(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 10, bottom: 25),
                    child: Text(
                      "Dodane dni wydarznia:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ))),
             ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.newEventDays.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 15, end: 10, bottom: 7),
                      child: Text(
                        state.newEventDays[index].dayOfEvent + " :",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      )),
                  subtitle: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                      state.newEventDays[index].eventElements.length,
                      itemBuilder: (BuildContext context, int i) {
                        return
                          Padding(padding: EdgeInsetsDirectional.only(
                              start: 15, bottom: 7),
                            child:
                            Text(state.newEventDays[index]
                                .eventElements[i].hour +
                                " - " +
                                state.newEventDays[index]
                                    .eventElements[i].title,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                )),
                          );
                      }),
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
                      context.read<EventsBloc>().add(NewEventDayDeleteEvent(state.newEventDays[index]));
                     
                    },
                  ),
                );

                  //
                  // Container(
                  //   child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //     Padding(
                  //         padding: EdgeInsetsDirectional.only(
                  //             start: 15, end: 10, bottom: 7),
                  //         child: Text(
                  //           state.newEventDays[index].dayOfEvent + " :",
                  //           style: TextStyle(
                  //               fontSize: 14, fontWeight: FontWeight.w600),
                  //         )),
                  //     ListView.builder(
                  //         shrinkWrap: true,
                  //         physics: const NeverScrollableScrollPhysics(),
                  //         itemCount:
                  //             state.newEventDays[index].eventElements.length,
                  //         itemBuilder: (BuildContext context, int i) {
                  //           return
                  //             Padding(padding: EdgeInsetsDirectional.only(
                  //           start: 15, bottom: 7),
                  //               child:
                  //             Text(state.newEventDays[index]
                  //                 .eventElements[i].hour +
                  //                 " - " +
                  //                 state.newEventDays[index]
                  //                     .eventElements[i].title,
                  //               style: const TextStyle(
                  //                 fontSize: 14.0,
                  //                 color: Colors.black,
                  //               )),
                  //             );
                  //         }),
                  //     const SizedBox(height: 10),
                  //   ]));
              })]);
        });
  }
}
