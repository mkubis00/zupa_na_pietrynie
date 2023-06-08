import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../content_holder/src/colors/colors.dart';
import '../../../bloc/events_bloc.dart';

class EventElementTitleInput extends StatelessWidget {
  const EventElementTitleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.newEventElementTitle != current.newEventElementTitle,
        builder: (context, state) {
          return TextFormField(
              key: const Key('loginForm_emailInput_textField'),
              initialValue: state.newEventElementTitle,
              cursorColor: AppColors.BLACK,
              maxLength: 120,
              onChanged: (String value) {
                context.read<EventsBloc>().add(NewEventElementTitleChangeEvent(value));
              },
              decoration: InputDecoration(
                labelText: 'Tytul elementu wydarzenia',
                contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(10)),
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.RED),
                    borderRadius: BorderRadius.circular(10)),
              ));
        });
  }
}
