part of 'main_page_bloc.dart';

enum PostStatus { initial, success, failure }

class MainPageState extends Equatable {
  const MainPageState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.newPostContent = "",
    this.newPostPhotos = const <File>[]
  });

  final PostStatus status;
  final List<Post> posts;
  final String newPostContent;
  final List<File?> newPostPhotos;

  MainPageState copyWith({
    PostStatus? status,
    List<Post>? posts,
    String? newPostContent,
    List<File?>? newPostPhotos
  }) {
    return MainPageState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      newPostContent: newPostContent ?? this.newPostContent,
      newPostPhotos: newPostPhotos ?? this.newPostPhotos
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, newPostContent, newPostPhotos];
}
