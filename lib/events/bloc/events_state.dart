part of 'events_bloc.dart';

class EventsState extends Equatable {
  const EventsState({
    this.newEvent = Event.empty,
    this.newEventStatus = FormzStatus.pure,
    this.newEventTitle = '',
    this.newEventDescription = '',
    this.newEventDays = const [],
  });

  final Event newEvent;
  final FormzStatus newEventStatus;
  final String newEventTitle;
  final String newEventDescription;
  final List<EventDay> newEventDays;

  EventsState copyWith({
    Event? newEvent,
    FormzStatus? newEventStatus,
    String? newEventTitle,
    String? newEventDescription,
  }) {
    return EventsState(
      newEvent: newEvent ?? this.newEvent,
      newEventStatus: newEventStatus ?? this.newEventStatus,
      newEventTitle: newEventTitle ?? this.newEventTitle,
      newEventDescription: newEventDescription ?? this.newEventDescription
    );
  }

  @override
  List<Object?> get props => [newEvent, newEventStatus, newEventTitle, newEventDescription];
}
