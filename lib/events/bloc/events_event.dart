part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

// Create event events

class NewEventTitleChangeEvent extends EventsEvent {
  final String newTitle;

  NewEventTitleChangeEvent(this.newTitle);
}

class NewEventDescriptionChangeEvent extends EventsEvent {
  final String newDescription;

  NewEventDescriptionChangeEvent(this.newDescription);
}

class NewEventPublishDateChangeEvent extends EventsEvent {
  final String newPublishDate;

  NewEventPublishDateChangeEvent(this.newPublishDate);
}

class NewEventDayAddEvent extends EventsEvent {
  NewEventDayAddEvent();
}

class NewEventDayDeleteEvent extends EventsEvent {
  final EventDay eventDayToDelete;

  NewEventDayDeleteEvent(this.eventDayToDelete);
}

class NewEventElementDeleteEvent extends EventsEvent {
  final EventElement eventElement;

  NewEventElementDeleteEvent(this.eventElement);
}

class EventElementToNewEventDayAddEvent extends EventsEvent {
  EventElementToNewEventDayAddEvent();
}

class NewEventElementTitleChangeEvent extends EventsEvent {
  final String newEventElementTitle;

  NewEventElementTitleChangeEvent(this.newEventElementTitle);
}

class NewEventElementHourChangeEvent extends EventsEvent {
  final String dateTime;

  NewEventElementHourChangeEvent(this.dateTime);
}

class NewEventDayChangeEvent extends EventsEvent {
  final String dayOfEvent;

  NewEventDayChangeEvent(this.dayOfEvent);
}

class _IsEventDayReadyEvent extends EventsEvent {
  _IsEventDayReadyEvent();
}

class _IsEventReadyToSubmitEvent extends EventsEvent {
  _IsEventReadyToSubmitEvent();
}

class NewEventCreateEvent extends EventsEvent {
  NewEventCreateEvent();
}

// Events

class EventsFetchEvent extends EventsEvent {}

class EventElementParticipationChangeEvent extends EventsEvent {
  final bool addParticipation;
  final EventElement eventElement;

  EventElementParticipationChangeEvent(this.addParticipation, this.eventElement);
}

class _EventElementUpdateStreamEvent extends EventsEvent {
  final EventElement eventElement;

  _EventElementUpdateStreamEvent(this.eventElement);
}

class EventDeleteEvent extends EventsEvent {
  final Event eventToDelete;

  EventDeleteEvent(this.eventToDelete);
}