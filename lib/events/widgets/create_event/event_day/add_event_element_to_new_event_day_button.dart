import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../content_holder/src/colors/colors.dart';
import '../../../bloc/events_bloc.dart';

class AddEventElementToNewEventDayButton extends StatelessWidget {
  const AddEventElementToNewEventDayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.newEventElementTitle != current.newEventElementTitle ||
            previous.newEventElementHour != current.newEventElementHour,
        builder: (context, state) {
          return Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: ElevatedButton(
                  key: const Key('create_post_button'),
                  child: const Text(
                    'Dodaj element wydarzenia',
                    style: const TextStyle(color: AppColors.WHITE),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.GREEN),
                  onPressed: state.newEventElementTitle.length > 5 &&
                          state.newEventElementHour != ''
                      ? () {
                          context
                              .read<EventsBloc>()
                              .add(EventElementToNewEventDayAddEvent());
                        }
                      : null));
        });
  }
}
