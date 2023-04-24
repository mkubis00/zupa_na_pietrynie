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
    );
  }

  @override
  List<Object?> get props => [
    newEvent,
    newEventStatus,
    newEventTitle,
    newEventDescription,
    newEventPublishDate,
    newEventDay,
    newEventDays,
    newEventElementTitle,
    newEventElementTitle,
    isNewPostReadyToSubmit,
  ];
}
