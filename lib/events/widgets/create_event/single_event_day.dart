import 'package:events_repository/events_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class SingleEventDay extends StatelessWidget {
  SingleEventDay({Key? key, required EventDay this.eventDay}) : super(key: key);

  final EventDay eventDay;
  final _hourController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      // color: Colors.blueAccent,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              Text(eventDay.dayOfEvent + ":", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              Spacer(),
              IconButton(
                icon: const Icon(
                  IconData(
                    0xe1b9,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: AppColors.FACEBOOK_BLUE,
                ),
                // the method which is called
                // when button is pressed
                onPressed: () {
                  context.read<EventsBloc>().add(DeleteNewEventDay(eventDay));
                },
              )
            ],
          ),
          const SizedBox(height: 5),
          EventDayElements(eventDay: eventDay),
          const SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: width * 0.05),
              SizedBox(
                  width: width * 0.3,
                  child:


                  TextFormField(
                      controller: _hourController,
                      key: UniqueKey(),
                      cursorColor: AppColors.BLACK,
                      decoration: InputDecoration(
                        labelText: 'Godzina',
                        contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)),
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: AppColors.RED),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        String selectedTimeString =
                            selectedTime!.hour.toString();
                        selectedTimeString +=
                            ":" + selectedTime!.minute.toString();
                        _hourController.text = selectedTimeString;
                      })),
              SizedBox(width: width * 0.035),
              SizedBox(
                  width: width * 0.5,
                  child: TextFormField(
                    controller: _titleController,
                    key: UniqueKey(),
                    decoration: InputDecoration(
                      labelText: 'Tytul wydarzenia',
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
                          borderSide:
                              BorderSide(width: 1, color: AppColors.RED),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
              SizedBox(width: width * 0.05),
            ],
          ),
          Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, width * 0.05, 10),
                  child: ElevatedButton(
                      key: const Key('create_post_button'),
                      child: const Text(
                        'Dodaj',
                        style: const TextStyle(color: AppColors.WHITE),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: AppColors.BLACK),
                      onPressed: () {
                        _hourController.text.length == 4 && _hourController.text[1] != ':' ? _hourController.value = _hourController.value.copyWith(text: _hourController.text + "0") : null;
                        context.read<EventsBloc>().add(AddNewEventElement(eventDay,
                            _hourController.text,
                            _titleController.text));
                      })))
        ],
      ),
    );
  }
}
