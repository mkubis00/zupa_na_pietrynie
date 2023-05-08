import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:events_repository/events_repository.dart';
import 'package:posts_repository/posts_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
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
    final User user = context.select((AppBloc bloc) => bloc.state.user);
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
                                        SwitchExample(),
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

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
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
