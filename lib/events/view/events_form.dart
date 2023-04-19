import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/app/app.dart';

class EventsForm extends StatelessWidget {
  const EventsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = context.read<AppBloc>().state.isAdmin;
    return BlocListener<EventsBloc, EventsState>(
        listener: (context, state) {

        },
      child: Scaffold(
        floatingActionButton: isAdmin ? FloatingActionButton(
        foregroundColor: AppColors.WHITE,
        backgroundColor: AppColors.BLACK,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateEventForm()),
          );
        },
        child: const Icon(Icons.add)) : null,
    body: Container(color: AppColors.FACEBOOK_BLUE,)),
    );
  }
}
