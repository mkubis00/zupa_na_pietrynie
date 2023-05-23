import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class EventTitleWindow extends StatelessWidget {
  const EventTitleWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.newEventTitle != current.newEventTitle,
        builder: (context, state) {
          return
              Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Row(
                      children: [
                        // const SizedBox(width: 10),
                        Text(
                          " Tytuł wydarzenia",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
          TextFormField(
                        initialValue: state.newEventTitle,
                        cursorColor: AppColors.BLACK,
                        key: const Key('loginForm_emailInput_textField'),
                        maxLength: 80,
                        onChanged: (title) => context
                            .read<EventsBloc>()
                            .add(NewEventTitleChangeEvent(title)),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                            focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey)),
                            errorText: state.newEventTitle.length < 10
                                ? 'zbyt krótki tytul'
                                : null,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(10)),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 1, color: AppColors.RED),
                                borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                ],
              );
        });
  }
}
