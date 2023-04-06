import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zupa_na_pietrynie/main_screen/bloc/main_screen_bloc.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<MainScreenBloc, MainScreenState>(
        buildWhen: (previous, current) => previous.commentsStatus != current.commentsStatus,
        builder: (context, state) {
          switch (state.commentsStatus) {
            case CommentsStatus.success:
              return Column(
                children: [
                  SizedBox(width: width * 0.9, child: Divider()),

                  SizedBox(width: width * 0.9, child: Divider()),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}
