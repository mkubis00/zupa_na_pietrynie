import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class PublishDateWindow extends StatelessWidget {
  const PublishDateWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) =>
            previous.newEventPublishDate != current.newEventPublishDate,
        builder: (context, state) {
          DateTime now = DateTime.now();
          String formattedDate =
          DateFormat('dd/MM/yyyy').format(now);
          context
              .read<EventsBloc>()
              .add(NewEventPublishDateChangeEvent(formattedDate));
          return Column(
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
                height: 140,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: state.newEventPublishDate != ''
                      ? DateFormat('dd/MM/yyyy hh:mm')
                          .parse(state.newEventPublishDate + ' 23:59')
                      : now,
                  minimumDate: now,
                  onDateTimeChanged: (DateTime newDateTime) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(newDateTime);
                    context
                        .read<EventsBloc>()
                        .add(NewEventPublishDateChangeEvent(formattedDate));
                  },
                ),
              ),
            ],
          );
        });
  }
}
