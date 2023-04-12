import 'dart:async';
import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
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
    on<CommentAdd>(_addNewComment);
    on<DeleteComment>(_commentDelete);
    on<UpdatePost>(_updatePost);
    on<InitUserSetUp>(_initUserSetUp);
    add(InitUserSetUp());
  }

  final PostsRepository _postsRepository;

  void _initUserSetUp(InitUserSetUp event, Emitter<MainScreenState> emit) {
    User user = _postsRepository.getCurrentUSer();
    Set<UserToPost> usersToPost= {};
    usersToPost.add(UserToPost(id: user.id, name: user.name!, photo: user.photo!));
    emit(state.copyWith(usersToPosts: usersToPost));
  }

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

  Future<void> _updatePost(UpdatePost event, Emitter<MainScreenState> emit) async {
      await _postsRepository.updatePost(event.postToUpdate, event.newContent);
      Post postToDelete = Post(ownerId: '', creationDate: '', postContent: '', numberOfComments: 0);
      Post postToAdd = Post(ownerId: '', creationDate: '', postContent: '', numberOfComments: 0);
      List<Post> newPosts = [];
      for(Post post in state.posts) {
        if(post.id == event.postToUpdate.id) {
          postToDelete = post;
          postToAdd = new Post(id: post.id, ownerId: post.ownerId, creationDate: post.creationDate, postContent: event.newContent, numberOfComments: post.numberOfComments, postPhotos: post.postPhotos);
        }
      }
      newPosts.addAll(state.posts);
      newPosts.remove(postToDelete);
      newPosts.add(postToAdd);
      newPosts.sort((a, b) => a.creationDate!.compareTo(b.creationDate!));
      emit(state.copyWith(posts: newPosts.reversed.toList(), postUpdateStatus: PostUpdateStatus.updated));
      emit(state.copyWith(postUpdateStatus: PostUpdateStatus.empty));
  }

  Future<void> _addNewComment(CommentAdd event, Emitter<MainScreenState> emit) async {
      await _postsRepository.createComment(event.commentContent, event.postId);
      Post postToDelete = Post(ownerId: '', creationDate: '', postContent: '', numberOfComments: 0);
      Post postToAdd = Post(ownerId: '', creationDate: '', postContent: '', numberOfComments: 0);
      List<Post> newPosts = [];
      for(Post post in state.posts) {
        if(post.id == event.postId) {
          postToDelete = post;
          postToAdd = new Post(id: post.id, ownerId: post.ownerId, creationDate: post.creationDate, postContent: post.postContent, numberOfComments: post.numberOfComments+1, postPhotos: post.postPhotos);
        }
      }
      newPosts.addAll(state.posts);
      newPosts.remove(postToDelete);
      newPosts.add(postToAdd);
      newPosts.sort((a, b) => a.creationDate!.compareTo(b.creationDate!));
      emit(state.copyWith(posts: newPosts.reversed.toList()));
  }


  Future<void> _postsFetch(PostFetched event, Emitter<MainScreenState> emit) async {
    if (event.fromBeginning) {
      List<Post> posts = await _postsRepository.postFetch(true);
      Set<UserToPost> usersToPosts = {};
      print("dlugosc " + usersToPosts.length.toString());
      usersToPosts.addAll(state.usersToPosts);

      usersToPosts.addAll(await _postsRepository.getUserstoPosts(posts));
      print("dlugosc " + usersToPosts.length.toString());
      print(usersToPosts);
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
      Set<UserToPost> usersToPosts = {};
      usersToPosts.addAll(state.usersToPosts);
      UserToPost help = UserToPost(id: _postsRepository.getCurrentUSer().id,
          name: _postsRepository.getCurrentUSer().name!,
          photo: _postsRepository.getCurrentUSer().photo!);
      usersToPosts.add(help);
      usersToPosts.addAll(await _postsRepository.getUserstoPosts(comments));
      Map<String, List<Comment>> commentsToState = {};
      commentsToState.addAll(state.comments);
      commentsToState.addAll({event.postId: comments});
      emit(state.copyWith(
          commentsStatus: CommentsStatus.success, comments: commentsToState, usersToPosts: usersToPosts));

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
      Post newPost =  await _postsRepository.createNewPost(
          state.newPostPhotos, state.newPostContent);
      List<Post> updatedPosts = state.posts;
      updatedPosts.insert(0, newPost);
      emit(state.copyWith(
        newPostStatus: FormzStatus.submissionSuccess,
        newPostPhotos: [],
        newPostContent: "",
      ));
      add(PostFetched(true));
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

  Future<void> _commentDelete(DeleteComment event, Emitter<MainScreenState> emit) async {
    await _postsRepository.deleteComment(event.commentToDelete.id!, event.commentToDelete.ownerId!, event.commentToDelete.postId);
    Map<String, List<Comment>> comments = state.comments;
    comments[event.commentToDelete.postId]?.remove(event.commentToDelete);
    Post postToDelete = Post(ownerId: '', creationDate: '', postContent: '', numberOfComments: 0);
    Post postToAdd = Post(ownerId: '', creationDate: '', postContent: '', numberOfComments: 0);
    List<Post> newPosts = [];
    for(Post post in state.posts) {
      if(post.id == event.commentToDelete.postId) {
        postToDelete = post;
        postToAdd = new Post(id: post.id, ownerId: post.ownerId, creationDate: post.creationDate, postContent: post.postContent, numberOfComments: post.numberOfComments-1, postPhotos: post.postPhotos);
      }
    }
    newPosts.addAll(state.posts);
    newPosts.remove(postToDelete);
    newPosts.add(postToAdd);
    newPosts.sort((a, b) => a.creationDate!.compareTo(b.creationDate!));
    emit(state.copyWith(comments: comments, commentDeleteStatus: CommentDeleteStatus.deleted, posts: newPosts.reversed.toList()));
    emit(state.copyWith(commentDeleteStatus: CommentDeleteStatus.empty));
  }
}
