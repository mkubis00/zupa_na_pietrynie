import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import '../bloc/main_page_bloc.dart';
import 'main_page_form.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MainPage());
  }

  @override
  Widget build(BuildContext context) {
    final PostsRepository _postsRepository = PostsRepository(
        authenticationRepository: context.read<AuthenticationRepository>());
    return Padding(
          padding: const EdgeInsets.all(8),
          child:
              // RepositoryProvider.value(
              //   value: _postsRepository,
              //   child:
                BlocProvider(
                  create: (_) => MainPageBloc(
                      PostsRepository(
                          authenticationRepository: context.read<AuthenticationRepository>())
                  ),
                  child: const MainPageForm(),
                ),
              // )
    );
  }
}
