import 'package:equatable/equatable.dart';


class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.isAdmin,
  });

  final String? email;

  final String id;

  final String? name;

  final String? photo;

  final bool? isAdmin;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, photo, isAdmin];

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'photo': photo,
    'isAdmin': isAdmin,
  };

  Map<String, dynamic> toJsonUserInit() => {
    'id': id,
    'email': email,
    'name': name,
    'photo': photo,
    'isAdmin': false,
  };
}