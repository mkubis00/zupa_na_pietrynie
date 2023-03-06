import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/main_page/bloc/main_page_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../../home/widgets/avatar.dart';

// class MainPageForm extends StatefulWidget {
//   const MainPageForm({Key? key}) : super(key: key);
//
//   @override
//   State<MainPageForm> createState() => _MainPageFormState();
// }

class MainPageForm extends StatelessWidget {
  const MainPageForm({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    double width = MediaQuery.of(context).size.width;
    return BlocListener<MainPageBloc, MainPageState>(
        listener: (context, state) {
        },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => PopUp(context));
          },
          child: const Icon(Icons.add),
        ),
        body: Align(
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
        )));
  }

  // @override
  // Widget build(BuildContext context) {
  //   double width = MediaQuery.of(context).size.width;
  //   return BlocListener<MainPageBloc, MainPageState>(
  //     listener: (context, state) {
  //     },
  //     child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text("dsds"),
  //             _PostContentInput()
  // ]
  //         ),
  //       ),
  //   );
  // }
}

class PopUp extends StatelessWidget {

  late BuildContext context1;

  PopUp(BuildContext this.context1);

  void zmianaTestu(String content) {
    context1.read<MainPageBloc>().
    add(PostAddContentChanged(Post(ownerId: "", creationDate: "", postContent: content)));
  }

  String getNewPostContent() {
    return context1.read<MainPageBloc>().state.newPost.postContent;
  }

  @override
  Widget build(BuildContext context) {
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    double width = MediaQuery.of(context).size.width;
    return SimpleDialog(
      insetPadding: EdgeInsets.all(10),
      title: Text("Dodaj nowy post"),
      alignment: Alignment.center,
      children: [
        Column(
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
              padding: EdgeInsets.symmetric(
                  horizontal: 15, vertical: 16),
              child: SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    initialValue: getNewPostContent(),
                    onChanged: (content) => zmianaTestu(content),
                    cursorColor: Colors.black,
                    maxLines: 6,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(),
                      hintText: 'Dodaj treść posta',
                    ),
                  )),
            ),
            Row(
              children: [
                SizedBox(width: 20),
                ElevatedButton(
                  key: const Key('loginForm_googleLogin_raisedButton'),
                  child: const Text(
                    'Wybierz zdjęcia',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white),
                  onPressed: () {

                  },
                ),
                Spacer(),
                ElevatedButton(
                  key: const Key('loginForm_googleLogin_'),
                  child: const Text(
                    'Opublikuj',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.black),
                  onPressed: () {
                  },
                ),
                SizedBox(width: 20),
              ],
            )
          ],
        )
      ],
    );
  }

}

class _PostContentInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageBloc, MainPageState>(
      buildWhen: (previous, current) => previous.newPost != current.newPost,
      builder: (context, state) {
        return TextField(
          onChanged: (content) => context.read<MainPageBloc>().
            add(PostAdd(Post(ownerId: "", creationDate: "", postContent: content))),
          cursorColor: Colors.black,
          maxLines: 6,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            border: UnderlineInputBorder(),
            hintText: 'Dodaj treść posta',
          ),
        );
      },
    );
  }
}