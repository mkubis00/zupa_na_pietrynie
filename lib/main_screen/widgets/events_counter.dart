import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class EventsCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final int eventsCounter = context.select(
        (MainScreenBloc mainScreenBloc) => mainScreenBloc.state.eventsCounter!);
    return BlocBuilder<MainScreenBloc, MainScreenState>(
        buildWhen: (previous, current) =>
            previous.eventsCounterState != current.eventsCounterState,
        builder: (context, state) {
          return state.eventsCounterState.name == "success"
              ? Container(
                  height: 100,
                  width: width * 0.98,
                  decoration: BoxDecoration(
                    color: AppColors.randomEventCounterColor(),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.GREY,
                          blurRadius: 10,
                          spreadRadius: 1)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          const Text(
                            MainScreenStrings.EVENTS_COUTER_MAIN_INSCRIPTION,
                            style:
                                TextStyle(fontSize: 23, color: AppColors.WHITE),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          const Text(
                            MainScreenStrings.EVENTS_COUNTER_SECOND_INSCRIPTION,
                            style:
                                TextStyle(fontSize: 16, color: AppColors.WHITE),
                          ),
                          Text(
                            eventsCounter.toString(),
                            style: TextStyle(
                              fontSize: 19,
                              color: AppColors.WHITE,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            MainScreenStrings
                                .EVENTS_COUNTER_SECOND_INSCRIPTION_2,
                            style:
                                TextStyle(fontSize: 16, color: AppColors.WHITE),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Container(
                  height: 100,
                  width: width * 0.93,
                  decoration: BoxDecoration(
                    color: AppColors.GREY,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.GREY,
                          blurRadius: 10,
                          spreadRadius: 1)
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(color: AppColors.BLACK),
                    ),
                  ));
        });
  }
}
