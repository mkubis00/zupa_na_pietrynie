part of 'main_screen_bloc.dart';

enum PostStatus { empty, success, failure }

enum EventsCounterStatus { initial, success, failure }

enum CommentsStatus { empty, success, failure }

enum CommentDeleteStatus { deleted, empty,failure }

enum PostUpdateStatus { updated, empty, failure }

class MainScreenState extends Equatable {
  const MainScreenState({
      this.postsStatus = PostStatus.empty,
      this.posts = const <Post>[],
      this.newPostContent = "",
      this.newPostPhotos = const <File>[],
      this.newPostStatus = FormzStatus.pure,
      this.errorMessage,
      this.eventsCounter = 0,
      this.eventsCounterState = EventsCounterStatus.initial,
      this.usersToPosts = const {},
      this.comments = const <String, List<Comment>>{},
      this.commentsStatus = CommentsStatus.empty,
      this.commentDeleteStatus = CommentDeleteStatus.empty,
      this.postUpdateStatus = PostUpdateStatus.empty,
      this.postDeleteStatus = FormzStatus.pure,
  });

  final PostStatus postsStatus;
  final List<Post> posts;
  final PostUpdateStatus postUpdateStatus;
  final FormzStatus postDeleteStatus;

  final String newPostContent;
  final List<File?> newPostPhotos;
  final FormzStatus newPostStatus;

  final String? errorMessage;

  final int eventsCounter;
  final EventsCounterStatus eventsCounterState;

  final Set<UserToPost> usersToPosts;

  final Map<String, List<Comment>> comments;
  final CommentsStatus commentsStatus;
  final CommentDeleteStatus commentDeleteStatus;



  MainScreenState copyWith({
    PostStatus? status,
    List<Post>? posts,
    String? newPostContent,
    List<File?>? newPostPhotos,
    FormzStatus? newPostStatus,
    String? errorMessage,
    int? eventsCounter,
    EventsCounterStatus? eventsCounterState,
    Set<UserToPost>? usersToPosts,
    Map<String, List<Comment>>? comments,
    CommentsStatus? commentsStatus,
    CommentDeleteStatus? commentDeleteStatus,
    PostUpdateStatus? postUpdateStatus,
    FormzStatus? postDeleteStatus,
  }) {
    return MainScreenState(
        postsStatus: status ?? this.postsStatus,
        posts: posts ?? this.posts,
        newPostContent: newPostContent ?? this.newPostContent,
        newPostPhotos: newPostPhotos ?? this.newPostPhotos,
        newPostStatus: newPostStatus ?? this.newPostStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        eventsCounter: eventsCounter ?? this.eventsCounter,
        eventsCounterState: eventsCounterState ?? this.eventsCounterState,
        usersToPosts: usersToPosts ?? this.usersToPosts,
        comments: comments ?? this.comments,
        commentsStatus: commentsStatus ?? this.commentsStatus,
        commentDeleteStatus: commentDeleteStatus ?? this.commentDeleteStatus,
        postUpdateStatus: postUpdateStatus ?? this.postUpdateStatus,
        postDeleteStatus: postDeleteStatus ?? this.postDeleteStatus,
    );

  }

  @override
  String toString() {
    return '''PostState { status: $postsStatus, posts: ${posts.length}, 
    comments ${comments.length}, commetsStatus ${commentsStatus}, 
    commetsDeleteStatus ${commentDeleteStatus}, postUpdateStatus ${postUpdateStatus}, 
    newPostContent ${newPostContent}, newPostStatus ${newPostStatus}, 
    eventsCounter ${eventsCounter}, eventsCounterState ${eventsCounterState}, 
    userToPost ${usersToPosts}''';
  }

  @override
  List<Object> get props => [
        postsStatus,
        posts,
        newPostContent,
        newPostPhotos,
        newPostStatus,
        eventsCounter,
        eventsCounterState,
        usersToPosts,
        comments,
        commentsStatus,
        commentDeleteStatus,
        postUpdateStatus,
        postDeleteStatus,
      ];
}
