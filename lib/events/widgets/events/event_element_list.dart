import 'package:flutter/material.dart';

import 'package:events_repository/events_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/app/app.dart';

class EventElementList extends StatelessWidget {
  const EventElementList({Key? key, required this.eventElements})
      : super(key: key);

  final List<EventElement> eventElements;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final String userId = context.select((AppBloc bloc) => bloc.state.user.id);
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: eventElements.length,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
              padding: EdgeInsetsDirectional.only(bottom: 5, top: 5),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  SwitchParticipation(
                    userId: userId,
                    eventElement: eventElements[i],
                    key: UniqueKey(),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                      width: width * 0.6,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: AppColors.BLACK,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: eventElements[i].hour +
                                    " - " +
                                    eventElements[i].title +
                                    "\nLiczba zgłoszeń: "),
                            TextSpan(
                                text: eventElements[i]
                                    .participants
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )),
                ],
              ));
        });
  }
}
