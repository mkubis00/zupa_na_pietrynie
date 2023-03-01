import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:equatable/equatable.dart';

part 'main_page_state.dart';

part 'main_page_event.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  MainPageBloc({required PostsRepository postsRepository})
      : _postsRepository = postsRepository,
        super(const MainPageState()) {
    on<PostFetched>(_onPostFetched);
  }

  final PostsRepository _postsRepository;

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<MainPageState> emit,
  ) async {
    print("dasdaaaaa");
      int test = await _postsRepository.getNumberOfPosts();
      print("dasd");
      print(test);
  }

  Future<void> _test (
      PostFetched event,
      Emitter<MainPageState> emit,
      ) async {

  }
}
