import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class EventDescription extends StatelessWidget {
  const EventDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.newEventDescription != current.newEventDescription,
        builder: (context, state) {
          return Container(
              width: width * 0.95,
              decoration: BoxDecoration(
                color: AppColors.WHITE,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.GREY, blurRadius: 5, spreadRadius: 1)
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          "Opis wydarzenia:",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: width * 0.9,
                      child: TextField(
                        cursorColor: AppColors.BLACK,
                        key: const Key('loginForm_emailInput_textField'),
                        maxLength: 500,
                        maxLines: 5,
                        onChanged: (description) => context
                            .read<EventsBloc>()
                            .add(EventDescriptionChangeEvent(description)),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.BLACK)),
                            errorText: state.newEventDescription.length < 10
                                ? 'zbyt krótki opis'
                                : null,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(10))),
                      )),
                  const SizedBox(height: 20),
                ],
              ));
        });
  }
}
