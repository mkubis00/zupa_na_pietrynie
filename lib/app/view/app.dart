import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/theme.dart';

import '../../main_screen/bloc/main_screen_bloc.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  // @override
  // Widget build(BuildContext context) {
  //   return RepositoryProvider.value(
  //     value: _authenticationRepository,
  //     child:
  //     BlocProvider(
  //       create: (_) => AppBloc(
  //         authenticationRepository: _authenticationRepository,
  //       ),
  //       child: const AppView(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child:
      MultiBlocProvider(
          providers: [
      BlocProvider<AppBloc>(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        )),
            BlocProvider<MainScreenBloc>(
                create: (BuildContext context) => MainScreenBloc(PostsRepository(
                    authenticationRepository:
                    context.read<AuthenticationRepository>()))..add(EventsCounterFetch())..add(PostFetched(true))),
          ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}