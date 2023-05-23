import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

import '../../settings_options/view/settings_options_page.dart';
import 'package:zupa_na_pietrynie/settings_options/settings_options.dart';
import 'package:zupa_na_pietrynie/events/events.dart';

class MainScreenForm extends StatefulWidget {
  const MainScreenForm({Key? key}) : super(key: key);

  @override
  State<MainScreenForm> createState() => _MainScreenFormState();
}

class _MainScreenFormState extends State<MainScreenForm> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MainScreenPage(),
    EventsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 30,
          backgroundColor: AppColors.BACKGROUND_COLOR,
          actions: <Widget>[
            Padding(padding: EdgeInsetsDirectional.only(bottom: 10), child:
            IconButton(
              key: const Key('homePage_logout_iconButton'),
              icon: const Icon(Icons.settings),
              color: AppColors.BLACK,
              onPressed: () =>
                  Navigator.of(context).push<void>(SettingOptionsPage.route()),
            ))
          ],
        ),
        body:
            //   Align(
            // alignment: const Alignment(0, -1 / 3),
            // child:
            _widgetOptions.elementAt(_selectedIndex),
        // ),
        bottomNavigationBar:
        Container(
          decoration: BoxDecoration(
            color: AppColors.GREEN,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.GREY,
                blurRadius: 0,
                offset: Offset(
                  0,
                  1,
                ),
              )
            ],
          ),
          child:
          BottomNavigationBar(
            elevation: 0,
            backgroundColor: AppColors.BACKGROUND_COLOR,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Posty',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconData(0xe78e, fontFamily: 'MaterialIcons')),
                label: 'Wydarzenia',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.GREEN,
            unselectedItemColor: AppColors.GREY,
            onTap: _onItemTapped,
          ),
        ));
  }
}
