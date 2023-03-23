import 'package:equatable/equatable.dart';

class UserToPost extends Equatable {
  const UserToPost({required this.id, required this.name, required this.photo});

  final String id;
  final String name;
  final String photo;

  @override
  List<Object?> get props => [id, name, photo];
}