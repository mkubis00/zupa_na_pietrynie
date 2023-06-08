part of 'events_bloc.dart';

class EventsState extends Equatable {
  const EventsState({
    this.newEvent = Event.empty,
    this.newEventStatus = FormzStatus.pure,
    this.newEventTitle = '',
    this.newEventDescription = '',
    this.newEventDays = const [],
    this.newEventPublishDate = '',
    this.newEventElementHour = '',
    this.newEventElementTitle = '',
    this.isNewEventReadyToSubmit = false,
    this.events = const <Event>[],
    this.eventsStatus = FormzStatus.pure,
    this.errorMessage = '',
    this.eventElementChangeStatus = FormzStatus.pure,
    this.eventDeletedStatus = FormzStatus.pure,
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

  //Fetching events
  final List<Event> events;
  final FormzStatus eventsStatus;
  final FormzStatus eventElementChangeStatus;
  final FormzStatus eventDeletedStatus;

  final String errorMessage;

  EventsState copyWith({
    Event? newEvent,
    FormzStatus? newEventStatus,
    String? newEventTitle,
    String? newEventDescription,
    String? newEventPublishDate,
    List<EventDay>? newEventDays,
    String? newEventElementTitle,
    String? newEventElementHour,
    bool? isNewEventReadyToSubmit,
    List<Event>? events,
    FormzStatus? eventsStatus,
    String? errorMessage,
    FormzStatus? eventElementChangeStatus,
    FormzStatus? eventDeletedStatus,
    EventDay? eventDayToCreate,
    bool? isEventDayReady,
  }) {
    return EventsState(
      newEvent: newEvent ?? this.newEvent,
      newEventStatus: newEventStatus ?? this.newEventStatus,
      newEventTitle: newEventTitle ?? this.newEventTitle,
      newEventDescription: newEventDescription ?? this.newEventDescription,
      newEventPublishDate: newEventPublishDate ?? this.newEventPublishDate,
      newEventDays: newEventDays ?? this.newEventDays,
      newEventElementHour: newEventElementHour ?? this.newEventElementHour,
      newEventElementTitle: newEventElementTitle ?? this.newEventElementTitle,
      isNewEventReadyToSubmit:
          isNewEventReadyToSubmit ?? this.isNewEventReadyToSubmit,
      events: events ?? this.events,
      eventsStatus: eventsStatus ?? this.eventsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      eventElementChangeStatus:
          eventElementChangeStatus ?? this.eventElementChangeStatus,
      eventDeletedStatus: eventDeletedStatus ?? this.eventDeletedStatus,
      eventDayToCreate: eventDayToCreate ?? this.eventDayToCreate,
      isEventDayReady: isEventDayReady ?? this.isEventDayReady,
    );
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
        newEventDays,
        newEventElementTitle,
        newEventElementHour,
        isNewEventReadyToSubmit,
        errorMessage,
        eventElementChangeStatus,
        eventDeletedStatus,
        eventDayToCreate,
        isEventDayReady,
      ];
}
