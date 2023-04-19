import 'package:equatable/equatable.dart';
import 'package:events_repository/events_repository.dart';

class Event extends Equatable {
  final String? id;
  final String title;
  final String description;
  final List<EventDay> eventDays;
  final String publishDate;

  const Event({
    this.id,
    required this.title,
    required this.description,
    required this.eventDays,
    required this.publishDate,
  });

  static const empty = Event(title: '', description: '', eventDays: [], publishDate: '');

  Event copyWith({
    String? id,
    String? title,
    String? description,
    List<EventDay>? eventDays,
    String? publishDate,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDays: eventDays ?? this.eventDays,
      publishDate: publishDate ?? this.publishDate,
    );
  }

  @override
  List<Object?> get props => [id, title, description, eventDays, publishDate];
}
