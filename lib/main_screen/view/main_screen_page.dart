import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class MainScreenPage extends StatelessWidget {
  const MainScreenPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MainScreenPage());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(8),
          child:
                BlocProvider(
                  create: (_) => MainScreenBloc(
                      PostsRepository(
                          authenticationRepository: context.read<AuthenticationRepository>())
                  ),
                  child: const MainScreenForm(),
                ),
    );
  }
}
