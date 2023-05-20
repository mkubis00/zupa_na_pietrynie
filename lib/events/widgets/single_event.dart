import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:events_repository/events_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class SingleEvent extends StatefulWidget {
  const SingleEvent(
      {Key? key, required Event this.event, required bool this.isAdmin})
      : super(key: key);

  final Event event;
  final bool isAdmin;

  @override
  State<SingleEvent> createState() => _SingleEventState(event, isAdmin);
}

class _SingleEventState extends State<SingleEvent> {
  final Event event;
  final bool isAdmin;

  _SingleEventState(this.event, this.isAdmin);

  bool isAfterPublishDate() {
    DateTime publishDateTime =
        DateFormat('dd-MM-yyyy').parse(event.publishDate);
    DateTime now = DateTime.now();
    now.compareTo(publishDateTime);
    if (now.compareTo(publishDateTime) < 0) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final String userId = context.select((AppBloc bloc) => bloc.state.user.id);
    return isAfterPublishDate()
        ? Container(
            decoration: BoxDecoration(
              color: AppColors.WHITE,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: AppColors.GREY, blurRadius: 10, offset: Offset(
                  0,
                  1,
                ),)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAdmin)
                  Row(
                    children: [
                      Spacer(),
                      SizedBox(
                        height: 35,
                        child: Padding(
                            padding:
                                EdgeInsetsDirectional.only(top: 0, end: 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),

                              // the method which is called
                              // when button is pressed
                              onPressed: ()
                                  =>
                                  showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Chcesz usunąć wydarznie?"),
                                  content: const Text("Pamiętaj, będzie to nieodwracalna zmiana!"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(MainScreenStrings.CANCEL,
                                          style: TextStyle(color: AppColors.BLACK)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<EventsBloc>().add(DeleteEvent(event));
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                          "Usuń",
                                          style: TextStyle(
                                              color: AppColors.RED)),
                                    )
                                  ],
                                ),
                              ),
                              child: Text("Usuń"),
                            )),
                      ) // Dodanie przycisku usuń/resetuj
                    ],
                  ),
                const SizedBox(height: 13),
                Padding(
                    padding: EdgeInsetsDirectional.only(start: 15, end: 10),
                    child: Text(
                      event.title,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    )),
                const SizedBox(height: 12),
                Padding(
                    padding: EdgeInsetsDirectional.only(start: 15, end: 10),
                    child: Text(
                      event.description,
                      style: TextStyle(fontSize: 15),
                    )),
                Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 15, end: 10, top: 10, bottom: 12),
                    child: Text(
                      'Dni wydarzenia:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: event.eventDays.length,
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
                                  event.eventDays[index].dayOfEvent + " :",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    event.eventDays[index].eventElements.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return
                                    Padding(padding: EdgeInsetsDirectional.only(bottom: 5,top: 5),
                                    child:
                                    Row(
                                    children: [
                                      const SizedBox(width: 18),
                                      // SwitchExample(event.eventDays[index].eventElements[i].participants),
                                      SwitchParticipation(
                                        userId: userId,
                                        eventElement: event
                                            .eventDays[index].eventElements[i],
                                        key: UniqueKey(),
                                      ),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                          width: width * 0.6,
                                          child: RichText(
                                            text: TextSpan(
                                              // Note: Styles for TextSpans must be explicitly defined.
                                              // Child text spans will inherit styles from parent
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: event
                                                            .eventDays[index]
                                                            .eventElements[i]
                                                            .hour +
                                                        " - " +
                                                        event
                                                            .eventDays[index]
                                                            .eventElements[i]
                                                            .title +
                                                        "\nLiczba zgłoszeń: "),
                                                TextSpan(
                                                    text: event
                                                        .eventDays[index]
                                                        .eventElements[i]
                                                        .participants
                                                        .length
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ));
                                }),
                            const SizedBox(height: 10),
                          ]));
                    }),
                const SizedBox(height: 20),
              ],
            ))
        : Container(
            child: Center(
              child: Text('Już niedługo dostęne nowe wydarzenie ...'),
            ),
          );
  }
}

class SwitchParticipation extends StatelessWidget {
  const SwitchParticipation(
      {Key? key,
      required String this.userId,
      required EventElement this.eventElement})
      : super(key: key);

  final String userId;
  final EventElement eventElement;

  bool _isPicked(String userId, List<String> participants) {
    return participants.contains(userId);
  }

  @override
  Widget build(BuildContext context) {
    bool light = _isPicked(userId, eventElement.participants);
    return Switch(
      key: UniqueKey(),
      value: light,
      activeColor: AppColors.GREEN,
      onChanged: (bool value) {
        context
            .read<EventsBloc>()
            .add(EventElementParticipationChange(value, eventElement));
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
