part of 'events_bloc.dart';

class EventsState extends Equatable {
  const EventsState({
    this.newEvent = Event.empty,
    this.newEventStatus = FormzStatus.pure,
    this.newEventTitle = '',
    this.newEventDescription = '',
    this.newEventDays = const [],
    this.newEventPublishDate = '',
    this.newEventDay = '',
    this.newEventElementHour = '',
    this.newEventElementTitle = '',
    this.isNewPostReadyToSubmit = false,
    this.events = const <Event>[],
    this.eventsStatus = FormzStatus.pure,
    this.errorMessage = '',
  });

  final Event newEvent;
  final FormzStatus newEventStatus;

  final String newEventPublishDate;
  final String newEventTitle;
  final String newEventDescription;

  final String newEventDay;
  final List<EventDay> newEventDays;

  final String newEventElementTitle;
  final String newEventElementHour;
  final bool isNewPostReadyToSubmit;

  final List<Event> events;
  final FormzStatus eventsStatus;

  final String errorMessage;

  EventsState copyWith({
    Event? newEvent,
    FormzStatus? newEventStatus,
    String? newEventTitle,
    String? newEventDescription,
    String? newEventPublishDate,
    String? newEventDay,
    List<EventDay>? newEventDays,
    String? newEventElementTitle,
    String? newEventElementHour,
    bool? isNewPostReadyToSubmit,
    List<Event>? events,
    FormzStatus? eventsStatus,
    String? errorMessage,
  }) {
    return EventsState(
      newEvent: newEvent ?? this.newEvent,
      newEventStatus: newEventStatus ?? this.newEventStatus,
      newEventTitle: newEventTitle ?? this.newEventTitle,
      newEventDescription: newEventDescription ?? this.newEventDescription,
      newEventPublishDate: newEventPublishDate ?? this.newEventPublishDate,
      newEventDay: newEventDay ?? this.newEventDay,
      newEventDays: newEventDays ?? this.newEventDays,
      newEventElementHour: newEventElementHour ?? this.newEventElementTitle,
      newEventElementTitle: newEventElementTitle ?? this.newEventElementTitle,
      isNewPostReadyToSubmit: isNewPostReadyToSubmit ?? this.isNewPostReadyToSubmit,
      events: events ?? this.events,
      eventsStatus: eventsStatus ?? this.eventsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }


  @override
  String toString() {
    return 'EventsState{events: $events}';
  }

  @override
  List<Object?> get props => [
    events,
    eventsStatus,
    newEvent,
    newEventStatus,
    newEventTitle,
    newEventDescription,
    newEventPublishDate,
    newEventDay,
    newEventDays,
    newEventElementTitle,
    newEventElementHour,
    isNewPostReadyToSubmit,
    errorMessage
  ];
}
