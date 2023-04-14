part of 'main_screen_bloc.dart';

class MainScreenState extends Equatable {
  const MainScreenState({
      this.postsFetchStatus = FormzStatus.pure,
      this.posts = const <Post>[],
      this.newPostContent = "",
      this.newPostPhotos = const <File>[],
      this.newPostStatus = FormzStatus.pure,
      this.errorMessage,
      this.eventsCounter = 0,
      this.eventsCounterState = FormzStatus.pure,
      this.usersToPosts = const {},
      this.comments = const <String, List<Comment>>{},
      this.commentsStatus = FormzStatus.pure,
      this.commentDeleteStatus = FormzStatus.pure,
      this.postUpdateStatus = FormzStatus.pure,
      this.postDeleteStatus = FormzStatus.pure,
      this.newCommentStatus = FormzStatus.pure,
  });

  final List<Post> posts;
  final FormzStatus postsFetchStatus;
  final FormzStatus postUpdateStatus;
  final FormzStatus postDeleteStatus;

  final String newPostContent;
  final List<File?> newPostPhotos;
  final FormzStatus newPostStatus;

  final String? errorMessage;

  final int eventsCounter;
  final FormzStatus eventsCounterState;

  final Set<UserToPost> usersToPosts;

  final Map<String, List<Comment>> comments;
  final FormzStatus commentsStatus;
  final FormzStatus commentDeleteStatus;
  final FormzStatus newCommentStatus;


  MainScreenState copyWith({
    FormzStatus? status,
    List<Post>? posts,
    String? newPostContent,
    List<File?>? newPostPhotos,
    FormzStatus? newPostStatus,
    String? errorMessage,
    int? eventsCounter,
    FormzStatus? eventsCounterState,
    Set<UserToPost>? usersToPosts,
    Map<String, List<Comment>>? comments,
    FormzStatus? commentsStatus,
    FormzStatus? commentDeleteStatus,
    FormzStatus? postUpdateStatus,
    FormzStatus? postDeleteStatus,
    FormzStatus? newCommentStatus,
  }) {
    return MainScreenState(
        postsFetchStatus: status ?? this.postsFetchStatus,
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
        newCommentStatus: newCommentStatus ?? this.newCommentStatus,
    );

  }

  // @override
  // String toString() {
  //   return '''PostState { status: $postsStatus, posts: ${posts.length},
  //   comments ${comments.length}, commetsStatus ${commentsStatus},
  //   commetsDeleteStatus ${commentDeleteStatus}, postUpdateStatus ${postUpdateStatus},
  //   newPostContent ${newPostContent}, newPostStatus ${newPostStatus},
  //   eventsCounter ${eventsCounter}, eventsCounterState ${eventsCounterState},
  //   userToPost ${usersToPosts}''';
  // }

  @override
  List<Object> get props => [
        postsFetchStatus,
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
        newCommentStatus,
      ];
}
