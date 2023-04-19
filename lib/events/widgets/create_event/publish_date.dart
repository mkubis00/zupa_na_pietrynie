import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:intl/intl.dart';


class PublishDate extends StatelessWidget {
  const PublishDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
        previous.newEventPublishDate != current.newEventPublishDate,
        builder: (context, state) {
          print("ELo");
          return Container(
              width: width * 0.935,
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
                          "Data opublikowania:",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: width * 0.88,
                      child: TextFormField(
                        key: UniqueKey(),
                          initialValue: state.newEventPublishDate,
                          // controller: TextEditingController(),
                          decoration:  InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                            focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey)),
                            icon: Icon(Icons.calendar_today, color: Colors.grey),
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
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate:DateTime.now(), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );
                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate!);
                            context.read<EventsBloc>().add(NewEventPublishDateChangeEvent(formattedDate));
                          }
                      )),
                  const SizedBox(height: 20),
                ],
              ));
        });
  }
}
