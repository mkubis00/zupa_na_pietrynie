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
  PostAdd();
}

class PostAddPhotosChanged extends MainPageEvent {

  final List<File?> photos;

  PostAddPhotosChanged(this.photos);
}

class PostAddContentChanged extends MainPageEvent {

  final String content;

  PostAddContentChanged(this.content);
}

class PostAddPhotoDeleted extends MainPageEvent {
  final int index;

  PostAddPhotoDeleted(this.index);
}