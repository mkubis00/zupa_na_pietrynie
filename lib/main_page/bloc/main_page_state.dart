part of 'main_page_bloc.dart';

enum PostStatus { initial, success, failure }

class MainPageState extends Equatable {
  const MainPageState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.newPost = Post.empty
  });

  final PostStatus status;
  final List<Post> posts;
  final Post newPost;

  MainPageState copyWith({
    PostStatus? status,
    List<Post>? posts,
    Post? newPost,
  }) {
    return MainPageState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      newPost: newPost ?? this.newPost
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, newPost];
}
