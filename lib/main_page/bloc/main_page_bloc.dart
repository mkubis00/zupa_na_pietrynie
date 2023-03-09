import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:equatable/equatable.dart';

part 'main_page_state.dart';

part 'main_page_event.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  MainPageBloc(this._postsRepository)
      :
        super(const MainPageState()) {
    on<PostFetched>(_test);
    on<PostAddContentChanged>(_postContentChanged);
    on<PostAddPhotosChanged>(_newPostPhotosChanged);
    on<PostAddPhotoDeleted>(_newPostPhotoDeleted);
    on<PostAdd>(_newPostAdd);
  }

  final PostsRepository _postsRepository;

  void _postContentChanged(PostAddContentChanged event, Emitter<MainPageState> emit) {
    emit(
      state.copyWith(
        newPostContent: event.content
      ),
    );
  }

  void _newPostPhotosChanged(PostAddPhotosChanged event, Emitter<MainPageState> emit) {
    emit(
      state.copyWith(
        newPostPhotos: event.photos
      ),
    );
  }

  void _test(PostFetched event, Emitter<MainPageState> emit) {
    print("TEST TUTAJ");
  }

  void _newPostPhotoDeleted(PostAddPhotoDeleted event, Emitter<MainPageState> emit) {
    state.newPostPhotos.removeAt(event.index);
    emit(
      state.copyWith(
        newPostPhotos: state.newPostPhotos
      )
    );
  }

  void _newPostAdd(PostAdd event, Emitter<MainPageState> emit) {

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
}
