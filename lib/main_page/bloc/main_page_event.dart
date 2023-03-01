part of 'main_page_bloc.dart';

abstract class MainPageEvent extends Equatable {
  @override
  List<Object> get props => [];

  const MainPageEvent();
}

class PostFetched extends MainPageEvent {
  const PostFetched();
}

class PostAdd extends MainPageEvent {
  final Post post;

  PostAdd(this.post);
}
