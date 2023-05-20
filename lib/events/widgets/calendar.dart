import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  static bool _isCurrentDay(_DayOfWeek _dayOfWeek) {
    DateTime now = DateTime.now();
    if (now.day.toString() == _dayOfWeek.day) {
      return true;
    } else {
      return false;
    }
  }

  static List<_DayOfWeek> _dataToCalendar() {
    DateTime now = DateTime.now();
    int help = 0;
    List<DateTime> week = [];
    week.add(now.subtract(Duration(days: now.weekday - 1)));
    for (help; help < 6; help++) {
      week.add(week[help].add(Duration(days: 1)));
    }
    List<_DayOfWeek> toReturn = [];
    for (DateTime element in week) {
      switch (element.weekday) {
        case 1:
          toReturn.add(_DayOfWeek(element.day.toString(),'Pon'));
          break;
        case 2:
          toReturn.add(_DayOfWeek(element.day.toString(),'Wt'));
          break;
        case 3:
          toReturn.add(_DayOfWeek(element.day.toString(),'Śr'));
          break;
        case 4:
          toReturn.add(_DayOfWeek(element.day.toString(),'Czw'));
          break;
        case 5:
          toReturn.add(_DayOfWeek(element.day.toString(),'Pt'));
          break;
        case 6:
          toReturn.add(_DayOfWeek(element.day.toString(),'Sb'));
          break;
        case 7:
          toReturn.add(_DayOfWeek(element.day.toString(),'Ndz'));
          break;
      }
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    final List<_DayOfWeek> week = _dataToCalendar();
    double width = MediaQuery.of(context).size.width;
    return
      Container(
        height: 60,
        child:
        ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, separatorInt) => SizedBox(
              width: 10,
            ),
            shrinkWrap: true,
            itemCount: week.length,
            itemBuilder: (BuildContext context, int index) {
              return _isCurrentDay(week[index]) ?
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.GREEN,
                  boxShadow: [
                    BoxShadow(color: AppColors.GREEN_SHADOW, blurRadius: 12, offset: Offset(
                      0,
                      1,
                    ),)
                  ],
                ),
                width: width * 0.1,
                child:
                Align(
                    alignment: AlignmentDirectional.center,
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(week[index].dayOfWeek,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        Text(week[index].day,
                          style: TextStyle(
                              fontSize: 12,
                            color: Colors.white
                          ),
                        ),
                      ],
                    )),
              )

                :
                Container(
                decoration: BoxDecoration(
                  color: week[index].dayOfWeek == 'Ndz' ? AppColors.RED : null,
                  borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: week[index].dayOfWeek == 'Ndz' ? AppColors.RED : Color.fromARGB(255, 187, 196, 213),
                      width: 1.5,
                    ),
                ),
                width: width * 0.1,
                child:
                Align(
                    alignment: AlignmentDirectional.center,
                    child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(week[index].dayOfWeek,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: week[index].dayOfWeek == 'Ndz' ? AppColors.WHITE : AppColors.BLACK
                    ),
                  ),
                  Text(week[index].day,
                      style: TextStyle(
                      fontSize: 12,
                          color: week[index].dayOfWeek == 'Ndz' ? AppColors.WHITE : AppColors.BLACK
                  ),
                  ),
                ],
              )),
              );
            })
    );
  }
}

class _DayOfWeek {
  final String day;
  final String dayOfWeek;

  _DayOfWeek(this.day, this.dayOfWeek);


}