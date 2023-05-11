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
    this.eventElementChangeStatus = FormzStatus.pure,
    this.eventDeleted = FormzStatus.pure,
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

  final FormzStatus eventElementChangeStatus;

  final FormzStatus eventDeleted;

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
    FormzStatus? eventElementChangeStatus,
    FormzStatus? eventDeleted,
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
      eventElementChangeStatus: eventElementChangeStatus ?? this.eventElementChangeStatus,
      eventDeleted: eventDeleted ?? this.eventDeleted,
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
    errorMessage,
    eventElementChangeStatus,
    eventDeleted,
  ];
}
