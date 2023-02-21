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

  final DateTime creationDate;

  final String postContent;

  final List<String>? postPhotos;

  @override
  List<Object?> get props => [id, ownerId, creationDate, postContent, postPhotos];
}