import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/events/bloc/events_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
        previous.isNewEventReadyToSubmit != current.isNewEventReadyToSubmit, // DO ZMIANY
        builder: (context, state) {
          return Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 5),
              child: ElevatedButton(
                key: const Key('create_post_button'),
                child: const Text(
                  'Utwórz',
                  style: const TextStyle(color: AppColors.WHITE),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.GREEN),
                onPressed: state.isNewEventReadyToSubmit ? () {
                  context.read<EventsBloc>().add(NewEventCreateEvent());
                  Navigator.pop(context);
                }: null,
              ));
        });
  }
}
