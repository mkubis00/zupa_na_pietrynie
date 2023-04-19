import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class EventTitle extends StatelessWidget {
  const EventTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
        previous.newEventTitle != current.newEventTitle,
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
                    child:
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text("Tytul wydarzenia:",
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
                    child:
                  TextField(
                    cursorColor: AppColors.BLACK,
                    key: const Key('loginForm_emailInput_textField'),
                    maxLength: 80,
                    onChanged: (title) =>
                        context.read<EventsBloc>().add(
                            EventTitleChangeEvent(title)),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.BLACK)),
                        errorText:
                            state.newEventTitle.length < 10 ? 'zbyt krótki tytul': null,
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
