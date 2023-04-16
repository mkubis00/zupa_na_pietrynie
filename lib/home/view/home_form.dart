import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

import '../../settings_options/view/settings_options_page.dart';
import 'package:zupa_na_pietrynie/settings_options/settings_options.dart';

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
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
        'Ten panel\nzostanie dodany\nwkrótce...',
        style: optionStyle,
      ),
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
        backgroundColor: AppColors.WHITE,
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.settings),
            color: AppColors.BLACK,
            onPressed: () =>
                Navigator.of(context).push<void>(SettingOptionsPage.route()),
          )
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:
      SizedBox(
        // height: 91,
        child:
      BottomNavigationBar(
        elevation: 0,
        backgroundColor: AppColors.WHITE,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Posty',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe78e, fontFamily: 'MaterialIcons')),
            label: 'Wydarzenia',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe054, fontFamily: 'MaterialIcons')),
            label: 'Pomoc Bezdomnym',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.BLACK,
        unselectedItemColor: AppColors.GREY,
        onTap: _onItemTapped,
      )),
    );
  }
}

