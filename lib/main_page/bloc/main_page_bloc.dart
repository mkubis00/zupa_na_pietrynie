import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:equatable/equatable.dart';

part 'main_page_state.dart';

part 'main_page_event.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  MainPageBloc(this._postsRepository)
      :
        super(const MainPageState()) {
    on<PostFetched>(_onPostFetched);
    on<PostAddContentChanged>(_postContentChanged);
    on<PostAddPhotoChanged>(_newPostPhotosChanged);
  }

  final PostsRepository _postsRepository;

  void _postContentChanged(PostAdd event, Emitter<MainPageState> emit) {
    print(event.newPost.postContent);
    emit(
      state.copyWith(
        newPost: event.newPost
      ),
    );
  }

  void _newPostPhotosChanged(PostAddPhotoChanged event, Emitter<MainPageState> emit) {
    emit(
      state.copyWith(
        newPost: event.newPost
      ),
    );
  }




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
