import 'package:equatable/equatable.dart';
import 'package:events_repository/events_repository.dart';

class EventDay extends Equatable {
  final String? id;
  final DateTime dayOfEvent;
  final String title;
  final List<EventElement> eventElements;

  const EventDay({
    this.id,
    required this.dayOfEvent,
    required this.title,
    required this.eventElements,
  });

  EventDay copyWith ({
    String? id,
    DateTime? dayOfEvent,
    String? title,
    List<EventElement>? eventElements,
  }) {
    return EventDay(
      id: id ?? this.id,
      dayOfEvent: dayOfEvent ?? this.dayOfEvent,
      title: title ?? this.title,
      eventElements: eventElements ?? this.eventElements,
    );
  }

  @override
  List<Object?> get props => [id, dayOfEvent, title, eventElements];
}
