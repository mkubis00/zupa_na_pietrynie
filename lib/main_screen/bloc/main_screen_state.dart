part of 'main_screen_bloc.dart';

enum PostStatus {
  initial,
  success,
  failure,
}

enum EventsCounterState {
  initial,
  success,
  failure,
}

class MainScreenState extends Equatable {
  const MainScreenState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.newPostContent = "",
    this.newPostPhotos = const <File>[],
    this.newPostStatus = FormzStatus.pure,
    this.errorMessage,
    this.eventsCounter = 0,
    this.eventsCounterState = EventsCounterState.initial,
    this.usersToPosts = const {},
  });

  final PostStatus status;
  final List<Post> posts;
  final String newPostContent;
  final List<File?> newPostPhotos;
  final FormzStatus newPostStatus;
  final String? errorMessage;
  final int eventsCounter;
  final EventsCounterState eventsCounterState;
  final Set<UserToPost> usersToPosts;

  MainScreenState copyWith(
      {PostStatus? status,
      List<Post>? posts,
      String? newPostContent,
      List<File?>? newPostPhotos,
      FormzStatus? newPostStatus,
      String? errorMessage,
      int? eventsCounter,
      EventsCounterState? eventsCounterState,
        Set<UserToPost>? usersToPosts
      }) {
    return MainScreenState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      newPostContent: newPostContent ?? this.newPostContent,
      newPostPhotos: newPostPhotos ?? this.newPostPhotos,
      newPostStatus: newPostStatus ?? this.newPostStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      eventsCounter: eventsCounter ?? this.eventsCounter,
      eventsCounterState: eventsCounterState ?? this.eventsCounterState,
      usersToPosts: usersToPosts ?? this.usersToPosts,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [
        status,
        posts,
        newPostContent,
        newPostPhotos,
        newPostStatus,
        eventsCounter,
        eventsCounterState,
        usersToPosts,
      ];
}
