import 'package:flutter/material.dart';

import 'package:events_repository/events_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

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
            .add(EventElementParticipationChangeEvent(value, eventElement));
      },
    );
  }
}