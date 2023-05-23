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
    this.isNewEventReadyToSubmit = false,
    this.events = const <Event>[],
    this.eventsStatus = FormzStatus.pure,
    this.errorMessage = '',
    this.eventElementChangeStatus = FormzStatus.pure,
    this.eventDeleted = FormzStatus.pure,
    this.eventDayToCreate = const EventDay(dayOfEvent: '', eventElements: []),
    this.isEventDayReady = false,
  });

  //Publish new event
  final Event newEvent;
  final FormzStatus newEventStatus;
  final bool isNewEventReadyToSubmit;

  //Creating new event
  final String newEventPublishDate;
  final String newEventTitle;
  final String newEventDescription;
  final List<EventDay> newEventDays;

  //Creating new event day with elements
  final EventDay eventDayToCreate;
  final String newEventElementTitle;
  final String newEventElementHour;
  final bool isEventDayReady;

  final String newEventDay; // usuniecie

  //Fetching events
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
    bool? isNewEventReadyToSubmit,
    List<Event>? events,
    FormzStatus? eventsStatus,
    String? errorMessage,
    FormzStatus? eventElementChangeStatus,
    FormzStatus? eventDeleted,
    EventDay? eventDayToCreate,
    bool? isEventDayReady,
  }) {
    return EventsState(
      newEvent: newEvent ?? this.newEvent,
      newEventStatus: newEventStatus ?? this.newEventStatus,
      newEventTitle: newEventTitle ?? this.newEventTitle,
      newEventDescription: newEventDescription ?? this.newEventDescription,
      newEventPublishDate: newEventPublishDate ?? this.newEventPublishDate,
      newEventDay: newEventDay ?? this.newEventDay,
      newEventDays: newEventDays ?? this.newEventDays,
      newEventElementHour: newEventElementHour ?? this.newEventElementHour,
      newEventElementTitle: newEventElementTitle ?? this.newEventElementTitle,
      isNewEventReadyToSubmit: isNewEventReadyToSubmit ?? this.isNewEventReadyToSubmit,
      events: events ?? this.events,
      eventsStatus: eventsStatus ?? this.eventsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      eventElementChangeStatus: eventElementChangeStatus ?? this.eventElementChangeStatus,
      eventDeleted: eventDeleted ?? this.eventDeleted,
      eventDayToCreate: eventDayToCreate ?? this.eventDayToCreate,
      isEventDayReady: isEventDayReady ?? this.isEventDayReady,
    );
  }


  @override
  String toString() {
    return 'EventsState{eventTitle: $newEventElementTitle, eventHour: $newEventElementHour}';
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
    isNewEventReadyToSubmit,
    errorMessage,
    eventElementChangeStatus,
    eventDeleted,
    eventDayToCreate,
    isEventDayReady,
  ];
}
