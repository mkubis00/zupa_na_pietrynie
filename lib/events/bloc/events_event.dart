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

class AddNewEventElement extends EventsEvent {

  final EventDay eventDay;
  final String hour;
  final String title;

  AddNewEventElement(this.eventDay, this.hour, this.title);
}

class DeleteNewEventElement extends EventsEvent {

  final EventDay eventDay;
  final EventElement eventElement;

  DeleteNewEventElement(this.eventDay, this.eventElement);
}

class NewEventCreate extends EventsEvent {

  NewEventCreate();
}

class EventsFetch extends EventsEvent {

  EventsFetch();
}