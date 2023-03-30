import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post(
      {this.id,
      required this.ownerId,
      required this.creationDate,
      required this.postContent, required this.numberOfComments,
      this.postPhotos

      });

  final String? id;
  final String ownerId;
  final String creationDate;
  final String postContent;
  final List<String>? postPhotos;
  final int numberOfComments;

  // static const empty = Post(ownerId: '', creationDate: '', postContent: '', numberOfComments: 0);

  @override
  List<Object?> get props =>
      [id, ownerId, creationDate, postContent, postPhotos];
}
