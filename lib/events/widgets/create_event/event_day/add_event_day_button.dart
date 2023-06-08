import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../content_holder/src/colors/colors.dart';
import '../../../bloc/events_bloc.dart';

class AddEventDayButton extends StatelessWidget {
  const AddEventDayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.isEventDayReady != current.isEventDayReady,
        builder: (context, state) {
          return Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: ElevatedButton(
                  child: const Text(
                    'Dodaj dzień do wydarzenia',
                    style: const TextStyle(color: AppColors.WHITE),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.GREEN),
                  onPressed: state.isEventDayReady ? () {
                    context.read<EventsBloc>().add(NewEventDayAddEvent());
                  } : null));
        });
  }
}
