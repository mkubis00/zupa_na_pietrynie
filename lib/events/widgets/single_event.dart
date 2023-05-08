

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:events_repository/events_repository.dart';
import 'package:posts_repository/posts_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/home/home.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class SingleEvent extends StatefulWidget {
  const SingleEvent(
      {Key? key,
        required Event this.event,
        required bool this.isAdmin})
      : super(key: key);

  final Event event;
  final bool isAdmin;

  @override
  State<SingleEvent> createState() =>
      _SingleEventState(event, isAdmin);
}

class _SingleEventState extends State<SingleEvent> {
  final Event event;
  final bool isAdmin;

  _SingleEventState(this.event, this.isAdmin);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final String userId = context.select((AppBloc bloc) => bloc.state.user.id);
    return Container(
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.GREY, blurRadius: 10, spreadRadius: 1)
          ],
        ),

        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(height: 20), // Dodanie przycisku usuń/resetuj
              ],
            ),

                Padding(
                    padding: EdgeInsetsDirectional.only(start: 15, end: 10),
                child:
                Text(event.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
                )),
            const SizedBox(height: 12),
            Padding(
                padding: EdgeInsetsDirectional.only(start: 15, end: 10),
                child:
                Text(event.description,
                  style: TextStyle(
                      fontSize: 15
                  ),
                )),
            Padding(
                padding: EdgeInsetsDirectional.only(start: 15, end: 10, top: 10, bottom: 12),
                child:
                Text('Dni wydarzenia:',
                  style: TextStyle(
                      fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: event.eventDays.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child:
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsetsDirectional.only(start: 15, end: 10, bottom: 7),
                                child:
                                Text(event.eventDays[index].dayOfEvent + " :",
                                  style: TextStyle(
                                      fontSize: 14,
                                    fontWeight: FontWeight.w600
                                  ),
                                )),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: event.eventDays[index].eventElements.length,
                              itemBuilder: (BuildContext context, int i) {
                                  return
                                    Row(
                                      children: [
                                        const SizedBox(width: 18),
                                        // SwitchExample(event.eventDays[index].eventElements[i].participants),
                                        SwitchParticipation(userId: userId, eventElement: event.eventDays[index].eventElements[i],key: UniqueKey(),),
                                        const SizedBox(width: 5),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: SizedBox(
                                              // width: width * 0.86,
                                              child: Text(event.eventDays[index].eventElements[i].hour + " - " + event.eventDays[index].eventElements[i].title + "\nLiczba zgłoszeń: " + event.eventDays[index].eventElements[i].participants.length.toString())),
                                        )
                                      ],
                                    );
                              }
                            ),
                            const SizedBox(height: 10),
                          ])
                  );
                }
            ),
            const SizedBox(height: 20),
          ],
        ));
  }
}


class SwitchParticipation extends StatelessWidget {
  const SwitchParticipation({Key? key, required String this.userId, required EventElement this.eventElement}) : super(key: key);


  final String userId;
  final EventElement eventElement;

  bool _isPicked(String userId, List<String> participants) {
    return participants.contains(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: _isPicked(userId, eventElement.participants),
      activeColor: Colors.green,
      onChanged: (bool value) {
        context.read<EventsBloc>().add(EventElementParticipationChange(value, eventElement));
        print(value);
      },
    );
  }
}



class SwitchExample extends StatefulWidget {


  final List<String> participants;

  SwitchExample(this.participants);

  @override
  State<SwitchExample> createState() => _SwitchExampleState(participants);
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = false;
  final List<String> participants;

  bool _isPicked(String userId, List<String> participants) {
    return participants.contains(userId);
  }


  _SwitchExampleState(this.participants);

  @override
  Widget build(BuildContext context) {
    print("dupa");
    final String userId = context.select((AppBloc bloc) => bloc.state.user.id);
    light = _isPicked(userId, participants);
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.green,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
