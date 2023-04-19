import 'package:equatable/equatable.dart';
import 'package:events_repository/events_repository.dart';

class EventDay extends Equatable {
  final String? id;
  final String dayOfEvent;
  final List<EventElement> eventElements;

  const EventDay({
    this.id,
    required this.dayOfEvent,
    required this.eventElements,
  });

  EventDay copyWith ({
    String? id,
    String? dayOfEvent,
    List<EventElement>? eventElements,
  }) {
    return EventDay(
      id: id ?? this.id,
      dayOfEvent: dayOfEvent ?? this.dayOfEvent,
      eventElements: eventElements ?? this.eventElements,
    );
  }

  @override
  List<Object?> get props => [id, dayOfEvent, eventElements];
}
