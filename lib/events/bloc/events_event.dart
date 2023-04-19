part of 'events_bloc.dart';

abstract class EventsEvent{
  const EventsEvent();
}

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

class NewEventDayValueChange extends EventsEvent {
  final String newEventDay;

  NewEventDayValueChange(this.newEventDay);
}

class AddNewEventDay extends EventsEvent {

  AddNewEventDay();
}

class DeleteNewEventDay extends EventsEvent {

  final EventDay eventDayToDelete;

  DeleteNewEventDay(this.eventDayToDelete);
}