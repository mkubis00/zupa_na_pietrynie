import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class EventsListController extends StatefulWidget {
  const EventsListController({Key? key}) : super(key: key);

  @override
  State<EventsListController> createState() => _EventsListControllerState();
}

class _EventsListControllerState extends State<EventsListController> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) => previous.events != current.events,
        builder: (context, state) {
          return EventsList(key: UniqueKey());
        });
  }
}
