part of 'events_bloc.dart';

abstract class EventsEvent{
  const EventsEvent();
}

class EventTitleChangeEvent extends EventsEvent {
  final String newTitle;

  EventTitleChangeEvent(this.newTitle);
}

class EventDescriptionChangeEvent extends EventsEvent {
  final String newDescription;

  EventDescriptionChangeEvent(this.newDescription);
}