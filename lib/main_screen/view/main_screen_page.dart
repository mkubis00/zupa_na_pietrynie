import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class MainScreenPage extends StatelessWidget {
  const MainScreenPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MainScreenPage());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
      child: const MainScreenForm(),
    );
  }
}
