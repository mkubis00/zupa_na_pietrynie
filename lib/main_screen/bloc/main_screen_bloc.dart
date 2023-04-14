import 'dart:async';
import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:posts_repository/posts_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:formz/formz.dart';
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
  MainScreenBloc(
    this._postsRepository,
  ) : super(const MainScreenState()) {
    on<PostsFetch>(_postsFetch,
        transformer: throttleDroppable(throttleDuration));
    on<NewPostContentChange>(_newPostContentChanged);
    on<NewPostPhotosChange>(_newPostPhotosChanged);
    on<NewPostPhotoDelete>(_newPostPhotoDeleted);
    on<PostCreate>(_postCreate);
    on<EventsCounterFetch>(_eventsCounterFetch);
    on<PostDelete>(_postDelete);
    on<CommentsFetch>(_commentsFetch);
    on<CommentCreate>(_commentCreate);
    on<CommentDelete>(_commentDelete);
    on<PostUpdate>(_postUpdate);
    on<InitUserSetUp>(_initUserSetUp);
    on<_PostUpdateStream>(_updatePostFromDbStream);
    add(InitUserSetUp());
    _postRepositorySubscription = _postsRepository.posts.listen((event) {
      add(_PostUpdateStream(event));
    });
  }

  final PostsRepository _postsRepository;

  late final StreamSubscription<Post> _postRepositorySubscription;

  StreamController<int> _controller = StreamController.broadcast();

  Stream<void> get widgetStateUpdate => _controller.stream;

  Future<void> _updatePostFromDbStream(
      _PostUpdateStream event, Emitter<MainScreenState> emit) async {
    try {
      if (state.posts.length > 0) {
        bool isInPosts = false;
        List<Post> posts = [];
        Set<UserToPost> usersToPost = {};
        posts.addAll(state.posts);
        for (Post post in posts) {
          if (post.id == event.postToUpdate.id) {
            posts.add(event.postToUpdate);
            posts.remove(post);
            isInPosts = true;
            break;
          }
        }
        if (!isInPosts) {
          posts.add(event.postToUpdate);
          usersToPost.addAll(state.usersToPosts);
          usersToPost.addAll(
              await _postsRepository.getUsersToPosts([event.postToUpdate]));
        }
        posts.sort((a, b) => a.creationDate!.compareTo(b.creationDate!));
        isInPosts
            ? emit(state.copyWith(posts: posts.reversed.toList()))
            : emit(state.copyWith(
                posts: posts.reversed.toList(), usersToPosts: usersToPost));
        _controller.sink.add(1);
      }
    } catch (_) {}
  }

  void _initUserSetUp(InitUserSetUp event, Emitter<MainScreenState> emit) {
    User user = _postsRepository.getCurrentUSer();
    Set<UserToPost> usersToPost = {};
    usersToPost
        .add(UserToPost(id: user.id, name: user.name!, photo: user.photo!));
    emit(state.copyWith(usersToPosts: usersToPost));
  }

  void _newPostPhotoDeleted(
      NewPostPhotoDelete event, Emitter<MainScreenState> emit) {
    List<File?> newPostPhotos = [];
    newPostPhotos.addAll(state.newPostPhotos);
    newPostPhotos.removeAt(event.index);
    emit(state.copyWith(newPostPhotos: newPostPhotos));
  }

  void _newPostContentChanged(
      NewPostContentChange event, Emitter<MainScreenState> emit) {
    emit(
      state.copyWith(newPostContent: event.content),
    );
  }

  void _newPostPhotosChanged(
      NewPostPhotosChange event, Emitter<MainScreenState> emit) {
    emit(
      state.copyWith(newPostPhotos: event.photos),
    );
  }

  Future<void> _postCreate(
      PostCreate event, Emitter<MainScreenState> emit) async {
    emit(state.copyWith(newPostStatus: FormzStatus.submissionInProgress));
    try {
      Post newPost = await _postsRepository.createNewPost(
          state.newPostPhotos, state.newPostContent);
      List<Post> updatedPosts = [];
      updatedPosts.addAll(state.posts);
      updatedPosts.insert(0, newPost);
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
      emit(state.copyWith(errorMessage: "", newPostStatus: FormzStatus.pure));
    } catch (_) {
      emit(state.copyWith(newPostStatus: FormzStatus.submissionFailure));
      emit(state.copyWith(newPostStatus: FormzStatus.pure));
    }
  }

  Future<void> _postsFetch(
      PostsFetch event, Emitter<MainScreenState> emit) async {
    try {
      Set<UserToPost> usersToPosts = {};
      if (event.fromBeginning) {
        List<Post> posts = await _postsRepository.postFetch(true);
        InitUserSetUp();
        usersToPosts.add(UserToPost.unknown);
        usersToPosts.addAll(await _postsRepository.getUsersToPosts(posts));
        emit(state.copyWith(
            posts: posts,
            usersToPosts: usersToPosts,
            status: PostStatus.success));
      } else {
        List<Post> posts = await _postsRepository.postFetch(false);
        usersToPosts.addAll(state.usersToPosts);
        usersToPosts.addAll(await _postsRepository.getUsersToPosts(posts));
        emit(state.copyWith(
            posts: state.posts + posts,
            usersToPosts: usersToPosts,
            status: PostStatus.success));
      }
    } on FireStoreException catch (e) {
      emit(state.copyWith(errorMessage: e.message, status: PostStatus.failure));
      emit(state.copyWith(errorMessage: "", status: PostStatus.empty));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
      emit(state.copyWith(status: PostStatus.empty));
    }
  }

  Future<void> _postDelete(
      PostDelete event, Emitter<MainScreenState> emit) async {
    try {
      await _postsRepository.deletePost(
          event.postToDelete.id!, event.postToDelete.ownerId);
      List<Post> posts = [];
      posts.addAll(state.posts);
      posts.remove(event.postToDelete);
      emit(state.copyWith(
          posts: posts, postDeleteStatus: FormzStatus.submissionSuccess));
      emit(state.copyWith(postDeleteStatus: FormzStatus.pure));
    } on FireStoreException catch (e) {
      emit(state.copyWith(
          errorMessage: e.message,
          postDeleteStatus: FormzStatus.submissionFailure));
      emit(
          state.copyWith(errorMessage: "", postDeleteStatus: FormzStatus.pure));
    } catch (_) {
      emit(state.copyWith(postDeleteStatus: FormzStatus.submissionFailure));
    }
  }

  Future<void> _postUpdate(
      PostUpdate event, Emitter<MainScreenState> emit) async {
    try {
      await _postsRepository.updatePost(event.postToUpdate, event.newContent);
      List<Post> newPosts = [];
      newPosts.addAll(state.posts);
      for (Post post in newPosts) {
        if (post.id == event.postToUpdate.id) {
          newPosts.add(Post(
              id: post.id,
              ownerId: post.ownerId,
              creationDate: post.creationDate,
              postContent: event.newContent,
              numberOfComments: post.numberOfComments,
              postPhotos: post.postPhotos));
          newPosts.remove(post);
          break;
        }
      }
      newPosts.sort((a, b) => a.creationDate!.compareTo(b.creationDate!));
      emit(state.copyWith(
          posts: newPosts.reversed.toList(),
          postUpdateStatus: PostUpdateStatus.updated));
      emit(state.copyWith(postUpdateStatus: PostUpdateStatus.empty));
    } on FireStoreException catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, postUpdateStatus: PostUpdateStatus.failure));
      emit(state.copyWith(
          errorMessage: "", postUpdateStatus: PostUpdateStatus.empty));
    } catch (_) {
      emit(state.copyWith(postUpdateStatus: PostUpdateStatus.failure));
      emit(state.copyWith(postUpdateStatus: PostUpdateStatus.empty));
    }
  }

  Future<void> _commentCreate(
      CommentCreate event, Emitter<MainScreenState> emit) async {
    try {
      await _postsRepository.createComment(event.commentContent, event.postId);
      Post postToDelete = Post.empty;
      Post postToAdd = Post.empty;
      List<Post> newPosts = [];
      for (Post post in state.posts) {
        if (post.id == event.postId) {
          postToDelete = post;
          postToAdd = new Post(
              id: post.id,
              ownerId: post.ownerId,
              creationDate: post.creationDate,
              postContent: post.postContent,
              numberOfComments: post.numberOfComments + 1,
              postPhotos: post.postPhotos);
        }
      }
      newPosts.addAll(state.posts);
      if (newPosts.indexOf(postToDelete) > 19) {
        newPosts.remove(postToDelete);
        newPosts.add(postToAdd);
        newPosts.sort((a, b) => a.creationDate!.compareTo(b.creationDate!));
        emit(state.copyWith(posts: newPosts.reversed.toList()));
      }
    } on FireStoreException catch (e) {
    } catch (_) {}
  }

  Future<void> _commentsFetch(
      CommentsFetch event, Emitter<MainScreenState> emit) async {
    try {
      emit(state.copyWith(commentsStatus: CommentsStatus.empty));
      List<Comment> comments =
          await _postsRepository.fetchComments(event.postId);
      Set<UserToPost> usersToPosts = {};
      usersToPosts.addAll(state.usersToPosts);
      UserToPost currentUser = UserToPost(
          id: _postsRepository.getCurrentUSer().id,
          name: _postsRepository.getCurrentUSer().name!,
          photo: _postsRepository.getCurrentUSer().photo!);
      usersToPosts.add(currentUser);
      usersToPosts.addAll(await _postsRepository.getUsersToPosts(comments));
      Map<String, List<Comment>> commentsToState = {};
      commentsToState.addAll(state.comments);
      commentsToState.addAll({event.postId: comments});
      emit(state.copyWith(
          commentsStatus: CommentsStatus.success,
          comments: commentsToState,
          usersToPosts: usersToPosts));
      emit(state.copyWith(commentsStatus: CommentsStatus.empty));
    } on FireStoreException catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, commentsStatus: CommentsStatus.failure));
      emit(state.copyWith(commentsStatus: CommentsStatus.empty));
    } catch (_) {
      emit(state.copyWith(commentsStatus: CommentsStatus.failure));
      emit(state.copyWith(commentsStatus: CommentsStatus.empty));
    }
  }

  Future<void> _commentDelete(
      CommentDelete event, Emitter<MainScreenState> emit) async {
    try {
      await _postsRepository.deleteComment(event.commentToDelete.id!,
          event.commentToDelete.ownerId!, event.commentToDelete.postId);
      Map<String, List<Comment>> comments = state.comments;
      comments[event.commentToDelete.postId]?.remove(event.commentToDelete);
      List<Post> newPosts = [];
      newPosts.addAll(state.posts);
      Post postToDelete = Post.empty;
      Post postToAdd = Post.empty;
      for (Post post in newPosts) {
        if (post.id == event.commentToDelete.postId) {
          postToAdd = new Post(
              id: post.id,
              ownerId: post.ownerId,
              creationDate: post.creationDate,
              postContent: post.postContent,
              numberOfComments: post.numberOfComments - 1,
              postPhotos: post.postPhotos);
          postToDelete = post;
          break;
        }
      }
      if (newPosts.indexOf(postToDelete) > 19) {
        newPosts.add(postToAdd);
        newPosts.sort((a, b) => a.creationDate!.compareTo(b.creationDate!));
        emit(state.copyWith(
            comments: comments,
            commentDeleteStatus: CommentDeleteStatus.deleted,
            posts: newPosts.reversed.toList()));
      } else {
        emit(state.copyWith(
            comments: comments,
            commentDeleteStatus: CommentDeleteStatus.deleted));
        emit(state.copyWith(commentDeleteStatus: CommentDeleteStatus.empty));
      }
    } on FireStoreException catch (e) {
    } catch (_) {}
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

  @override
  Future<void> close() {
    _postRepositorySubscription.cancel();
    return super.close();
  }
}
