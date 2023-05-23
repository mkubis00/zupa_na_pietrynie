import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

import '../../widgets/create_event/event_days_list.dart';

class CreateEventForm extends StatelessWidget {
  const CreateEventForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: AppBar(
          title: const Text(
            "Stwórz wydarzenie",
            style: TextStyle(color: AppColors.BLACK),
          ),
          backgroundColor: AppColors.BACKGROUND_COLOR,
          shadowColor: AppColors.BACKGROUND_COLOR,
          elevation: 0,
          leading: BackButton(
            color: AppColors.GREEN,
          ),
          actions: <Widget>[CreateEventButton()],
        ),
        body: Padding(
            padding: EdgeInsetsDirectional.only(
                start: width * 0.05, end: width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  EventTitleWindow(),
                  const SizedBox(height: 25),
                  EventDescriptionWindow(),
                  const SizedBox(height: 25),
                  PublishDateWindow(),
                  const SizedBox(height: 15),
                  Divider(color: Colors.black,thickness: 2),
                  const SizedBox(height: 15),
                  CreateEventDay(),
                  Divider(color: Colors.black,thickness: 2),
                  const SizedBox(height: 30),

                  EventDaysList(),
                  // EventDaysWindow(),
                  const SizedBox(height: 50),
                ],
              ),
            )));
  }
}
