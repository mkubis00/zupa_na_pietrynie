import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:formz/formz.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'main_screen_state.dart';

part 'main_screen_event.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc(this._postsRepository) : super(const MainScreenState()) {
    on<PostFetched>(_postsFetch,
      transformer: throttleDroppable(throttleDuration));
    on<PostAddContentChanged>(_postContentChanged);
    on<PostAddPhotosChanged>(_newPostPhotosChanged);
    on<PostAddPhotoDeleted>(_newPostPhotoDeleted);
    on<PostAdd>(_newPostAdd);
    on<EventsCounterFetch>(_eventsCounterFetch);
    on<DeletePost>(_postDelete);
    on<FetchComments>(_fetchComments);
  }

  final PostsRepository _postsRepository;

  void _postContentChanged(
      PostAddContentChanged event, Emitter<MainScreenState> emit) {
    emit(
      state.copyWith(newPostContent: event.content),
    );
  }

  void _newPostPhotosChanged(
      PostAddPhotosChanged event, Emitter<MainScreenState> emit) {
    emit(
      state.copyWith(newPostPhotos: event.photos),
    );
  }

  Future<void> _postsFetch(PostFetched event, Emitter<MainScreenState> emit) async {
    if (event.fromBeginning) {
      List<Post> posts = await _postsRepository.postFetch(true);
      Set<UserToPost> usersToPosts = {};
      usersToPosts.addAll(state.usersToPosts);
      usersToPosts.addAll(await _postsRepository.getUserstoPosts(posts));
      usersToPosts.add(UserToPost(id: "unknown", name: "Usunięty użytkownik", photo: ""));
      emit(
        state.copyWith(posts: posts,
            usersToPosts: usersToPosts,
            status: PostStatus.success)
      );
    } else {
      List<Post> posts = await _postsRepository.postFetch(false);
      Set<UserToPost> usersToPosts = {};
      usersToPosts.addAll(state.usersToPosts);
      usersToPosts.addAll(await _postsRepository.getUserstoPosts(posts));
      emit(state.copyWith(posts: state.posts + posts, usersToPosts: usersToPosts, status: PostStatus.success));
    }

  }

  void _newPostPhotoDeleted(PostAddPhotoDeleted event, Emitter<MainScreenState> emit) {
    state.newPostPhotos.removeAt(event.index);
    emit(state.copyWith(newPostPhotos: state.newPostPhotos));
  }

  Future<void> _fetchComments(FetchComments event, Emitter<MainScreenState> emit ) async {
    try {
      emit(state.copyWith(commentsStatus: CommentsStatus.empty));
      List<Comment> comments = await _postsRepository.fetchComments(
          event.postId);
      emit(state.copyWith(
          commentsStatus: CommentsStatus.success, comments: comments));
    } on FireStoreException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message, commentsStatus: CommentsStatus.failure
      ));
    } catch (_) {
      emit(state.copyWith(commentsStatus: CommentsStatus.failure));
    }
  }

  Future<void> _newPostAdd(PostAdd event, Emitter<MainScreenState> emit) async {
    emit(state.copyWith(newPostStatus: FormzStatus.submissionInProgress));
    try {
      await _postsRepository.createNewPost(
          state.newPostPhotos, state.newPostContent);
      emit(state.copyWith(
        newPostStatus: FormzStatus.submissionSuccess,
        newPostPhotos: [],
        newPostContent: "",
      ));
      emit(state.copyWith(newPostStatus: FormzStatus.pure));
    } on FireStoreException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        newPostStatus: FormzStatus.submissionFailure,
      ));
    } catch (_) {
      emit(state.copyWith(newPostStatus: FormzStatus.submissionFailure));
    }
  }

  Future<void> _eventsCounterFetch(
      EventsCounterFetch event, Emitter<MainScreenState> emit) async {
    try {
      if (state.eventsCounter == 0) {
        int eventsCounter = await _postsRepository.eventsCounterFetch();
        emit(state.copyWith(
            eventsCounter: eventsCounter,
            eventsCounterState: EventsCounterStatus.success));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(eventsCounterState: EventsCounterStatus.failure));
    } catch (_) {
      emit(state.copyWith(eventsCounterState: EventsCounterStatus.failure));
    } finally {
      this.state.eventsCounterState.name == 'failure'
          ? {
              await Future.delayed(Duration(seconds: 3)),
              this.add(EventsCounterFetch())
            }
          : null;
    }
  }

  Future<void> _postDelete(DeletePost event, Emitter<MainScreenState> emit) async {
    await _postsRepository.deletePost(event.postToDelete.id!, event.postToDelete.ownerId);
    List<Post> posts = [];
    posts.addAll(state.posts);
    posts.remove(event.postToDelete);
    emit(state.copyWith(posts: posts));
  }
}
