part of 'main_page_bloc.dart';

enum PostStatus { initial, success, failure }

class MainPageState extends Equatable {
  const MainPageState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
  });

  final PostStatus status;
  final List<Post> posts;

  MainPageState copyWith({
    PostStatus? status,
    List<Post>? posts,
  }) {
    return MainPageState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts];
}
