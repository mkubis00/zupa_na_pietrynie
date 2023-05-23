import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:events_repository/events_repository.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

part 'events_event.dart';

part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(this._eventsRepository) : super(const EventsState()) {
    on<NewEventTitleChangeEvent>(_onEventTitleChange);
    on<NewEventDescriptionChangeEvent>(_onEventDescriptionChange);
    on<NewEventPublishDateChangeEvent>(_onEventPublishDateChange);
    on<AddNewEventDay>(_addNewEventDayToEvent);
    on<DeleteNewEventDay>(_deleteNewEventDay);
    on<DeleteNewEventElement>(_deleteNewEventElement);
    on<NewEventCreate>(_eventCreate);
    on<EventsFetch>(_eventsFetch);
    on<EventElementParticipationChange>(_eventElementParticipationChange);
    on<_EventElementUpdateStream>(_updateEventFromDbStream);
    on<DeleteEvent>(_eventDelete);
    on<EventDateDayOfEventToCreateChange>(_eventDateDayOfEventToCreateChange);
    on<NewEventElementTitleChange>(_newEventElementTitleChange);
    on<NewEventElementHourChange>(_newEventElementHourChange);
    on<AddEventElementToNewEventDay>(_addEventElementToNewEventDay);
    on<_IsEventDayReady>(_isEventDayReady);
    on<_IsEventReadyToSubmit>(_isEventReadyToSubmit);
    _eventRepositorySubscription =
        _eventsRepository.eventElement.listen(cancelOnError: false, (event) {
      add(_EventElementUpdateStream(event));
    });
  }

  final EventsRepository _eventsRepository;

  late final StreamSubscription<EventElement> _eventRepositorySubscription;

  Future<void> _updateEventFromDbStream(
      _EventElementUpdateStream event, Emitter<EventsState> emit) async {
    try {
      List<Event> events = [];
      events.addAll(state.events);
      List<EventElement> newEventElements = [];
      List<EventDay> newEventDays = [];
      bool isEventElementChanged = false;
      for (Event eventInEvents in events) {
        for (EventDay eventDay in eventInEvents.eventDays) {
          for (EventElement eventElement in eventDay.eventElements) {
            if (eventElement.id == event.eventElement.id) {
              newEventElements.addAll(eventDay.eventElements);
              newEventElements.add(event.eventElement);
              newEventElements.remove(eventElement);
              newEventElements.sort((a, b) => DateFormat('HH:mm')
                  .parse(a.hour)!
                  .compareTo(DateFormat('HH:mm').parse(b.hour)));
              isEventElementChanged = true;
              break;
            }
          }
          if (isEventElementChanged) {
            newEventDays.addAll(eventInEvents.eventDays);
            newEventDays
                .add(eventDay.copyWith(eventElements: newEventElements));
            newEventDays.remove(eventDay);
            newEventDays.sort((a, b) => DateFormat('dd/MM/yy')
                .parse(a.dayOfEvent.substring(0, 8))!
                .compareTo(DateFormat('dd/MM/yy')
                    .parse(b.dayOfEvent.substring(0, 8)!)));
            break;
          }
        }
        if (isEventElementChanged) {
          events.insert(0, eventInEvents.copyWith(eventDays: newEventDays));
          events.remove(eventInEvents);
          events.sort((a, b) => DateFormat('dd/MM/yy')
              .parse(a.eventDays[0].dayOfEvent.substring(0, 8))!
              .compareTo(DateFormat('dd/MM/yy')
                  .parse(b.eventDays[0].dayOfEvent.substring(0, 8))!));
          break;
        }
      }
      emit(state.copyWith(events: events));
    } catch (_) {
      print("duap");
    }
  }

  void _isEventDayReady(_IsEventDayReady event, Emitter<EventsState> emit) {
    bool isReady = true;
    print(state.eventDayToCreate.dayOfEvent);
    print(state.eventDayToCreate.eventElements.length);
    if (state.eventDayToCreate.dayOfEvent == '') isReady = false;
    if (state.eventDayToCreate.eventElements.length == 0) isReady = false;
    print(isReady);
    emit(state.copyWith(isEventDayReady: isReady));
  }

  void _isEventReadyToSubmit(_IsEventReadyToSubmit event, Emitter<EventsState> emit) {
    bool isReady = true;
    if (state.newEventTitle.length < 10) {
      isReady = false;
    } else if (state.newEventDescription.length < 10) {
      isReady = false;
    } else if (state.newEventPublishDate.length == "") {
      isReady = false;
    } else if (state.newEventDays.length < 1) {
      isReady = false;
    }
    emit(state.copyWith(isNewEventReadyToSubmit: isReady));
  }

  void _addEventElementToNewEventDay(
      AddEventElementToNewEventDay event, Emitter<EventsState> emit) {
    List<EventElement> updatedEventElements = [];
    updatedEventElements.addAll(state.eventDayToCreate.eventElements);
    updatedEventElements.add(EventElement(
        title: state.newEventElementTitle,
        hour: state.newEventElementHour,
        participants: const []));
    updatedEventElements.sort((a, b) => DateFormat('HH:mm')
        .parse(a.hour)
        .compareTo(DateFormat('HH:mm').parse(b.hour)));
    emit(state.copyWith(
        eventDayToCreate: state.eventDayToCreate
            .copyWith(eventElements: updatedEventElements),
        newEventElementHour: '',
        newEventElementTitle: ''));
    add(_IsEventDayReady());
  }

  void _eventDateDayOfEventToCreateChange(
      EventDateDayOfEventToCreateChange event, Emitter<EventsState> emit) {
    emit(state.copyWith(
        eventDayToCreate:
            state.eventDayToCreate.copyWith(dayOfEvent: event.dayOfEvent)));
    add(_IsEventDayReady());
  }

  void _newEventElementTitleChange(
      NewEventElementTitleChange event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventElementTitle: event.newEventElementTitle));
  }

  void _newEventElementHourChange(
      NewEventElementHourChange event, Emitter<EventsState> emit) {
    String formattedHour = DateFormat('HH:mm').format(event.dateTime);
    emit(state.copyWith(newEventElementHour: formattedHour));
  }

  void _onEventTitleChange(
      NewEventTitleChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventTitle: event.newTitle));
    add(_IsEventReadyToSubmit());
  }

  void _onEventDescriptionChange(
      NewEventDescriptionChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventDescription: event.newDescription));
    add(_IsEventReadyToSubmit());
  }

  void _onEventPublishDateChange(
      NewEventPublishDateChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventPublishDate: event.newPublishDate));
    add(_IsEventReadyToSubmit());
  }

  void _addNewEventDayToEvent(AddNewEventDay event, Emitter<EventsState> emit) {
    bool isDayDateExists = false;
    List<EventDay> eventDays = [];
    eventDays.addAll(state.newEventDays);
    for (EventDay eventDay in eventDays) {
      if (eventDay.dayOfEvent == state.eventDayToCreate.dayOfEvent) {
        isDayDateExists = true;
        break;
      }
    }
    if (!isDayDateExists) {
      eventDays.add(state.eventDayToCreate);
      eventDays.sort((a, b) => DateFormat('dd/MM/yy')
          .parse(a.dayOfEvent.substring(0, 8))!
          .compareTo(
              DateFormat('dd/MM/yy').parse(b.dayOfEvent.substring(0, 8))!));
      emit(state.copyWith(
          newEventDays: eventDays,
          eventDayToCreate: EventDay(dayOfEvent: '', eventElements: [])));
      emit(state.copyWith(
          isEventDayReady: false));
      add(_IsEventReadyToSubmit());
    }
  }

  void _deleteNewEventDay(DeleteNewEventDay event, Emitter<EventsState> emit) {
    List<EventDay> eventDays = [];
    eventDays.addAll(state.newEventDays);
    eventDays.remove(event.eventDayToDelete);
    emit(state.copyWith(newEventDays: eventDays));
    add(_IsEventReadyToSubmit());
  }

  // void _addNewEventElement(
  //     AddNewEventElement event, Emitter<EventsState> emit) {
  //   for (EventDay eventDay in state.newEventDays) {
  //     if (eventDay == event.eventDay) {
  //       List<EventElement> eventElements = [];
  //       EventDay newEventDay;
  //       eventElements.addAll(eventDay.eventElements);
  //       eventElements.add(EventElement(
  //           title: event.title, hour: event.hour, participants: []));
  //       eventElements.sort((a, b) => a.hour!.compareTo(b.hour!));
  //       newEventDay = eventDay.copyWith(eventElements: eventElements);
  //       List<EventDay> newEventDays = [];
  //       newEventDays.addAll(state.newEventDays);
  //       newEventDays.remove(eventDay);
  //       newEventDays.add(newEventDay);
  //       newEventDays.sort((a, b) => a.dayOfEvent!.compareTo(b.dayOfEvent!));
  //       emit(state.copyWith(newEventDays: newEventDays));
  //       emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
  //       break;
  //     }
  //   }
  // }

  void _deleteNewEventElement(
      DeleteNewEventElement event, Emitter<EventsState> emit) {
    List<EventElement> eventElements = [];
    eventElements.addAll(state.eventDayToCreate.eventElements);
    eventElements.remove(event.eventElement);
    emit(state.copyWith(
        eventDayToCreate:
            state.eventDayToCreate.copyWith(eventElements: eventElements)));
    add(_IsEventDayReady());
    add(_IsEventReadyToSubmit());
  }

  bool isNewPostReadyToSubmit() {
    if (state.newEventTitle.length < 10) {
      return false;
    } else if (state.newEventDescription.length < 10) {
      return false;
    } else if (state.newEventPublishDate.length == "") {
      return false;
    } else if (state.newEventDays.length < 1) {
      return false;
    }
    return true;
  }

  Future<void> _eventCreate(
      NewEventCreate event, Emitter<EventsState> emit) async {
    try {
      Event newEvent = Event(
          title: state.newEventTitle,
          description: state.newEventDescription,
          eventDays: state.newEventDays,
          publishDate: state.newEventPublishDate);
      Event createdEvent = await _eventsRepository.createNewEvent(newEvent);
      List<Event> events = [];
      events.add(createdEvent);
      events.addAll(state.events);
      events.sort((a, b) => DateFormat('dd/MM/yy')
          .parse(a.eventDays[0].dayOfEvent.substring(0, 8))!
          .compareTo(DateFormat('dd/MM/yy')
              .parse(b.eventDays[0].dayOfEvent.substring(0, 8))!));
      emit(state.copyWith(
        newEventStatus: FormzStatus.submissionSuccess,
        newEventTitle: '',
        newEventDescription: '',
        newEventPublishDate: '',
        newEventDays: [],
        events: events,
      ));
    } catch (_) {
      emit(state.copyWith(newEventStatus: FormzStatus.submissionFailure));
    } finally {
      emit(state.copyWith(newEventStatus: FormzStatus.pure));
    }
  }

  Future<void> _eventsFetch(
      EventsFetch event, Emitter<EventsState> emit) async {
    try {
      List<Event> events = await _eventsRepository.fetchEvents();
      emit(state.copyWith(eventsStatus: FormzStatus.pure));
      emit(state.copyWith(
          events: events, eventsStatus: FormzStatus.submissionSuccess));
    } on FireStoreException catch (e) {
      emit(state.copyWith(
          errorMessage: e.message,
          eventsStatus: FormzStatus.submissionFailure));
      emit(state.copyWith(errorMessage: "", eventsStatus: FormzStatus.pure));
    } catch (_) {
      emit(state.copyWith(eventsStatus: FormzStatus.submissionFailure));
      emit(state.copyWith(eventsStatus: FormzStatus.pure));
    }
  }

  Future<void> _eventElementParticipationChange(
      EventElementParticipationChange event, Emitter<EventsState> emit) async {
    try {
      List<String> participants = [];
      participants.addAll(event.eventElement.participants);
      if (event.addParticipation) {
        participants.add(_eventsRepository.getCurrentUser().id);
        print(_eventsRepository.getCurrentUser().id);
      } else {
        participants.remove(_eventsRepository.getCurrentUser().id);
      }
      await _eventsRepository.updateEventElementParticipation(
          event.eventElement.id!, participants);
    } catch (_) {
      emit(state.copyWith(
          eventElementChangeStatus: FormzStatus.submissionFailure));
      emit(state.copyWith(eventElementChangeStatus: FormzStatus.pure));
    }
  }

  Future<void> _eventDelete(
      DeleteEvent event, Emitter<EventsState> emit) async {
    try {
      await _eventsRepository.deleteEvent(event.eventToDelete);
      List<Event> events = [];
      events.addAll(state.events);
      events.remove(event.eventToDelete);
      emit(state.copyWith(
          events: events, eventDeleted: FormzStatus.submissionSuccess));
    } on FireStoreException catch (e) {
      emit(state.copyWith(eventDeleted: FormzStatus.submissionFailure));
    } catch (_) {
      emit(state.copyWith(eventDeleted: FormzStatus.submissionFailure));
    } finally {
      emit(state.copyWith(eventDeleted: FormzStatus.pure));
    }
  }

  @override
  Future<void> close() {
    _eventRepositorySubscription.cancel();
    return super.close();
  }
}
