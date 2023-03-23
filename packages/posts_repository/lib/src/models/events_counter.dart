import 'package:equatable/equatable.dart';

class EventsCounter extends Equatable {
  const EventsCounter({required this.id, required this.lastTimeUpdated, required this.count});

  final String lastTimeUpdated;
  final int count;
  final String id;

  static const empty = EventsCounter(id: "", lastTimeUpdated: 'Nieznana', count: 69);

  @override
  List<Object?> get props => [count, lastTimeUpdated];
}
