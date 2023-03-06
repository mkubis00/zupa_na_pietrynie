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
  final Post newPost;

  PostAdd(this.newPost);
}

class PostAddPhotoChanged extends PostAdd {
  PostAddPhotoChanged(super.newPost);
}

class PostAddContentChanged extends PostAdd {
  PostAddContentChanged(super.newPost);
}
