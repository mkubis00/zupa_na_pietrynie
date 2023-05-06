import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:events_repository/events_repository.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class SingleEvent extends StatelessWidget {
  const SingleEvent({Key? key, required Event this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.newEventDescription != current.newEventDescription,
        builder: (context, state) {
          return Container(
              key: UniqueKey(),
              decoration: BoxDecoration(
                color: AppColors.WHITE,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.GREY, blurRadius: 5, spreadRadius: 1)
                ],
              ),
              child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

                  Text(event.title,
                      maxLines: 5,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )),

              const SizedBox(height: 20),
              Text("fdfdf"),
              Text("fdfdf"),
              Text("fdfdf"),
              Text("fdfdf"),Text("fdfdf"),
              Text("fdfdf"),
              Text("fdfdf"),
              Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),
              Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),Text("fdfdf"),



            ],
          )

          );
        });
  }
}
