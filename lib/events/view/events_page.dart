import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const EventsPage());
  }

  @override
  Widget build(BuildContext context) {
    return const EventsForm();
  }
}
