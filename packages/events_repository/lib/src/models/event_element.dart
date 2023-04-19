import 'package:equatable/equatable.dart';

class EventElement extends Equatable {
  final String? id;
  final String title;
  final DateTime hour;
  final List<String> participants;

  const EventElement({
    this.id,
    required this.title,
    required this.hour,
    required this.participants,
  });

  EventElement copyWith({
    String? id,
    String? title,
    DateTime? hour,
    List<String>? participants,
  }) {
    return EventElement(
        id: id ?? this.id,
        title: title ?? this.title,
        hour: hour ?? this.hour,
        participants: participants ?? this.participants);
  }

  @override
  List<Object?> get props => [id, title, hour, participants];
}
