part of 'main_screen_bloc.dart';

enum PostStatus {
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
  });

  final PostStatus status;
  final List<Post> posts;
  final String newPostContent;
  final List<File?> newPostPhotos;
  final FormzStatus newPostStatus;
  final String? errorMessage;

  MainScreenState copyWith(
      {PostStatus? status,
      List<Post>? posts,
      String? newPostContent,
      List<File?>? newPostPhotos,
      FormzStatus? newPostStatus,
      String? errorMessage}) {
    return MainScreenState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      newPostContent: newPostContent ?? this.newPostContent,
      newPostPhotos: newPostPhotos ?? this.newPostPhotos,
      newPostStatus: newPostStatus ?? this.newPostStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props =>
      [status, posts, newPostContent, newPostPhotos, newPostStatus];
}
