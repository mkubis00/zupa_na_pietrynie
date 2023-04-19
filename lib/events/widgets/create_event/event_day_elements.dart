import 'package:events_repository/events_repository.dart';
import 'package:flutter/material.dart';

import '../../../content_holder/src/colors/colors.dart';

class EventDayElements extends StatelessWidget {
  const EventDayElements({Key? key, required EventDay this.eventDay})
      : super(key: key);

  final EventDay eventDay;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(

        ),
      ],
    );
  }
}
