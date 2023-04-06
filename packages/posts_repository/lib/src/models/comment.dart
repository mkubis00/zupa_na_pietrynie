import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  const Comment({
    this.id,
    this.ownerId,
    required this.postId,
    required this.commentContent,
    this.creationDate
});

  final String? id;
  final String? ownerId;
  final String postId ;
  final String commentContent;
  final String? creationDate;

  @override
  List<Object?> get props => [id, ownerId, postId, commentContent, creationDate];
}