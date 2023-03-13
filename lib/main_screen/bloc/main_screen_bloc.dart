import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:equatable/equatable.dart';

part 'main_screen_state.dart';
part 'main_screen_event.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc(this._postsRepository)
      :
        super(const MainScreenState()) {
    on<PostFetched>(_test);
    on<PostAddContentChanged>(_postContentChanged);
    on<PostAddPhotosChanged>(_newPostPhotosChanged);
    on<PostAddPhotoDeleted>(_newPostPhotoDeleted);
    on<PostAdd>(_newPostAdd);
  }

  final PostsRepository _postsRepository;

  void _postContentChanged(PostAddContentChanged event, Emitter<MainScreenState> emit) {
    emit(
      state.copyWith(
        newPostContent: event.content
      ),
    );
  }

  void _newPostPhotosChanged(PostAddPhotosChanged event, Emitter<MainScreenState> emit) {
    emit(
      state.copyWith(
        newPostPhotos: event.photos
      ),
    );
  }

  void _test(PostFetched event, Emitter<MainScreenState> emit) {
    print("TEST TUTAJ");
  }

  void _newPostPhotoDeleted(PostAddPhotoDeleted event, Emitter<MainScreenState> emit) {
    state.newPostPhotos.removeAt(event.index);
    emit(
      state.copyWith(
        newPostPhotos: state.newPostPhotos
      )
    );
  }

  Future<void> _newPostAdd(PostAdd event, Emitter<MainScreenState> emit) async {
    emit(state.copyWith(newPostStatus: FormzStatus.submissionInProgress));
    try {
      await _postsRepository.createNewPost(state.newPostPhotos, state.newPostContent);
      emit(state.copyWith(newPostStatus: FormzStatus.submissionSuccess));
    } on FireStoreException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          newPostStatus: FormzStatus.submissionFailure,
        )
      );
    } catch (_) {
      emit(state.copyWith(newPostStatus: FormzStatus.submissionFailure));
    }
  }
}
