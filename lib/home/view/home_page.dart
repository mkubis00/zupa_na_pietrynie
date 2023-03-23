import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/main_screen/bloc/main_screen_bloc.dart';
import 'package:zupa_na_pietrynie/home/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainScreenBloc>(
            create: (BuildContext context) => MainScreenBloc(PostsRepository(
                authenticationRepository:
                    context.read<AuthenticationRepository>()))..add(EventsCounterFetch())..add(PostFetched(true))),
      ],
      child: MainScreenForm(),
    );
  }
}
