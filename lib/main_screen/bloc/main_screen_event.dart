part of 'main_screen_bloc.dart';

abstract class MainScreenEvent extends Equatable {
  @override
  List<Object> get props => [];

  const MainScreenEvent();
}

class PostFetched extends MainScreenEvent {
  final bool fromBeginning;

  const PostFetched(this.fromBeginning);
}

class PostAdd extends MainScreenEvent {
  PostAdd();
}

class PostAddPhotosChanged extends MainScreenEvent {
  final List<File?> photos;

  PostAddPhotosChanged(this.photos);
}

class PostAddContentChanged extends MainScreenEvent {
  final String content;

  PostAddContentChanged(this.content);
}

class PostAddPhotoDeleted extends MainScreenEvent {
  final int index;

  PostAddPhotoDeleted(this.index);
}

class EventsCounterFetch extends MainScreenEvent {
  EventsCounterFetch();
}

class DeletePost extends MainScreenEvent {
  final Post postToDelete;

  DeletePost(this.postToDelete);
}

class UpdatePost extends MainScreenEvent {
  final Post postToUpdate;

  UpdatePost(this.postToUpdate);
}

class FetchComments extends MainScreenEvent {
  final String postId;

  FetchComments(this.postId);
}