import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const EventsPage());
  }

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 1, right: 1),
      child:
      const EventsForm(),
    );
  }
}