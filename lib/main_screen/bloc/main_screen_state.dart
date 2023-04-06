part of 'main_screen_bloc.dart';

enum PostStatus {
  initial,
  success,
  failure,
}

enum EventsCounterStatus {
  initial,
  success,
  failure,
}

enum CommentsStatus { empty, success, failure }

class MainScreenState extends Equatable {
  const MainScreenState(
      {this.postsStatus = PostStatus.initial,
      this.posts = const <Post>[],
      this.newPostContent = "",
      this.newPostPhotos = const <File>[],
      this.newPostStatus = FormzStatus.pure,
      this.errorMessage,
      this.eventsCounter = 0,
      this.eventsCounterState = EventsCounterStatus.initial,
      this.usersToPosts = const {},
      this.comments = const <Comment>[],
      this.commentsStatus = CommentsStatus.empty});

  final PostStatus postsStatus;
  final List<Post> posts;
  final String newPostContent;
  final List<File?> newPostPhotos;
  final FormzStatus newPostStatus;
  final String? errorMessage;
  final int eventsCounter;
  final EventsCounterStatus eventsCounterState;
  final Set<UserToPost> usersToPosts;
  final List<Comment> comments;
  final CommentsStatus commentsStatus;

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
    List<Comment>? comments,
    CommentsStatus? commentsStatus,
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
        commentsStatus: commentsStatus ?? this.commentsStatus);
  }

  @override
  String toString() {
    return '''PostState { status: $postsStatus, posts: ${posts.length} }''';
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
      ];
}
