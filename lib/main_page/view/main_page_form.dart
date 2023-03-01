import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/main_page/bloc/main_page_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../../home/widgets/avatar.dart';

class MainPageForm extends StatefulWidget {
  const MainPageForm({Key? key}) : super(key: key);

  @override
  State<MainPageForm> createState() => _MainPageFormState();
}

class _MainPageFormState extends State<MainPageForm> {
  @override
  Widget build(BuildContext context) {
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {

        showDialog(context: context, builder: (_) =>

            SimpleDialog(
              insetPadding: EdgeInsets.all(10),
          title: Text("Dodaj nowy post"),
          alignment: Alignment.center,
          children: [Column(
            children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
               SizedBox(
                width: 45,
                height: 45,
                child: Avatar(photo: user.photo),
              ),
                SizedBox(width: 20),
                Text(user.name!),
              ],
            ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                child: SizedBox(
                    width: width*0.90,
                    child:
                TextField(
                  maxLines: 6,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a search term',
                  ),
                )),
              ),
            ],

          )],
        ));
    },
    child: const Icon(Icons.add),
    ),
      body:
      Align(
      alignment: const Alignment(0, -1.8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/bloc_logo_small.png',
                  height: 170,
                )),
              ],
            ),
        ),
      ));
  }
}
