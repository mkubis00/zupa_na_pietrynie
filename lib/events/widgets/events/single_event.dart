import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:events_repository/events_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
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
        DateFormat('dd/MM/yyyy').parse(event.publishDate);
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
    return isAfterPublishDate()
        ? Container(
            decoration: BoxDecoration(
              color: AppColors.WHITE,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.GREY,
                  blurRadius: 10,
                  offset: Offset(
                    0,
                    1,
                  ),
                )
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
                                EdgeInsetsDirectional.only(top: 15, end: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.RED,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                              ),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Chcesz usunąć wydarznie?"),
                                  content: const Text(
                                      "Pamiętaj, będzie to nieodwracalna zmiana!"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                          MainScreenStrings.CANCEL,
                                          style: TextStyle(
                                              color: AppColors.BLACK)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<EventsBloc>()
                                            .add(EventDeleteEvent(event));
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Usuń",
                                          style:
                                              TextStyle(color: AppColors.RED)),
                                    )
                                  ],
                                ),
                              ),
                              child: Text("Usuń"),
                            )),
                      )
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
                EventDaysList(eventDays: event.eventDays),
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