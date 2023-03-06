import 'package:equatable/equatable.dart';

class Post extends Equatable {

  const Post({
    this.id,
    required this.ownerId,
    required this.creationDate,
    required this.postContent,
    this.postPhotos
});

  final String? id;

  final String ownerId;

  final String creationDate;

  final String postContent;

  final List<String>? postPhotos;

  static const empty = Post(ownerId: '', creationDate: '', postContent: '');

  @override
  List<Object?> get props => [id, ownerId, creationDate, postContent, postPhotos];
}