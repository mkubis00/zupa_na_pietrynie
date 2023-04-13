part of 'main_screen_bloc.dart';

abstract class MainScreenEvent extends Equatable {
  @override
  List<Object> get props => [];

  const MainScreenEvent();
}

class PostsFetch extends MainScreenEvent {
  final bool fromBeginning;

  const PostsFetch(this.fromBeginning);
}

class PostCreate extends MainScreenEvent {
  PostCreate();
}

class NewPostPhotosChange extends MainScreenEvent {
  final List<File?> photos;

  NewPostPhotosChange(this.photos);
}

class NewPostContentChange extends MainScreenEvent {
  final String content;

  NewPostContentChange(this.content);
}

class NewPostPhotoDelete extends MainScreenEvent {
  final int index;

  NewPostPhotoDelete(this.index);
}

class EventsCounterFetch extends MainScreenEvent {
  EventsCounterFetch();
}

class PostDelete extends MainScreenEvent {
  final Post postToDelete;

  PostDelete(this.postToDelete);
}

class PostUpdate extends MainScreenEvent {
  final Post postToUpdate;
  final String newContent;

  PostUpdate(this.postToUpdate, this.newContent);
}

class CommentsFetch extends MainScreenEvent {
  final String postId;

  CommentsFetch(this.postId);
}

class CommentCreate extends MainScreenEvent {
  final String commentContent;
  final String postId;

  CommentCreate(this.commentContent, this.postId);
}

class CommentDelete extends MainScreenEvent {
  final Comment commentToDelete;

  CommentDelete(this.commentToDelete);
}

class InitUserSetUp extends MainScreenEvent {}
