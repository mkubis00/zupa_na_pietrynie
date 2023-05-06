import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class EventsList extends StatelessWidget {
  const EventsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) => previous.events != current.events,
        builder: (context, state) {
          if (state.eventsStatus.isSubmissionSuccess) {
            return Align(
              alignment: Alignment.topCenter,
                child: Container(
                    width: width * 0.7,
                    child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        key: UniqueKey(),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 20,
                            ),
                        itemCount: state.events.length,
                        itemBuilder: (context, index) {
                          return SingleEvent(
                              key: UniqueKey(), event: state.events[index]);
                        })));
          } else {
            return BottomLoader();
          }
        });
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
