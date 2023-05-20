import 'package:authentication_repository/authentication_repository.dart';
import 'package:events_repository/events_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/events/events.dart';
import 'package:zupa_na_pietrynie/theme.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
              create: (_) => AppBloc(
                    authenticationRepository: _authenticationRepository,
                  )),
          BlocProvider<MainScreenBloc>(
              create: (BuildContext context) => MainScreenBloc(PostsRepository(
                  authenticationRepository:
                      context.read<AuthenticationRepository>()))
                ..add(EventsCounterFetch())
                ..add(PostsFetch(true))),
          BlocProvider<EventsBloc>(
              create: (BuildContext context) => EventsBloc(EventsRepository(authenticationRepository:
              context.read<AuthenticationRepository>()))
                  ..add(EventsFetch())
          ),
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
      debugShowCheckedModeBanner: false,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
