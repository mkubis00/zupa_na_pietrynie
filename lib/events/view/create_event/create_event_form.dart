import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class CreateEventForm extends StatelessWidget {
  const CreateEventForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomSheet: ,
        appBar: AppBar(
          title: const Text(
            "Stwórz wydarzenie",
            style: TextStyle(color: AppColors.BLACK),
          ),
          backgroundColor: AppColors.WHITE,
          shadowColor: AppColors.WHITE,
          elevation: 0,
          leading: BackButton(
            color: AppColors.BLACK,
          ),
          actions: <Widget>[CreateEventButton()],
        ),
        body: Align(
            alignment: AlignmentDirectional.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  EventTitle(),
                  const SizedBox(height: 20),
                  EventDescription()
                ],
              ),
            )));
  }
}
