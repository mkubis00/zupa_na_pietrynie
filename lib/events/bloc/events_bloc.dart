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
    on<NewEventDayValueChange>(_onNewEventValueChange);
    on<AddNewEventDay>(_addNewEventDayToEvent);
    on<DeleteNewEventDay>(_deleteNewEventDay);
    on<AddNewEventElement>(_addNewEventElement);
    on<DeleteNewEventElement>(_deleteNewEventElement);
    on<NewEventCreate>(_eventCreate);
    on<EventsFetch>(_eventsFetch);
    on<EventElementParticipationChange>(_eventElementParticipationChange);
    on<_EventElementUpdateStream>(_updateEventFromDbStream);
    on<DeleteEvent>(_eventDelete);
    _eventRepositorySubscription =
        _eventsRepository.eventElement.listen(cancelOnError: false,(event) {
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
            newEventDays.sort((a, b) => DateFormat('dd-MM')
                .parse(a.dayOfEvent.substring(0, 5))!
                .compareTo(
                    DateFormat('dd-MM').parse(b.dayOfEvent.substring(0, 5)!)));
            break;
          }
        }
        if (isEventElementChanged) {
          events.insert(0, eventInEvents.copyWith(eventDays: newEventDays));
          events.remove(eventInEvents);
          events.sort((a, b) => DateFormat('dd-MM')
              .parse(a.eventDays[0].dayOfEvent.substring(0, 5))!
              .compareTo(DateFormat('dd-MM')
                  .parse(b.eventDays[0].dayOfEvent.substring(0, 5))!));
          break;
        }
      }
      emit(state.copyWith(events: events));
    } catch (_) {
      print("duap");
    }
  }

  void _onEventTitleChange(
      NewEventTitleChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventTitle: event.newTitle));
    emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
  }

  void _onEventDescriptionChange(
      NewEventDescriptionChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventDescription: event.newDescription));
    emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
  }

  void _onEventPublishDateChange(
      NewEventPublishDateChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventPublishDate: event.newPublishDate));
    emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
  }

  void _onNewEventValueChange(
      NewEventDayValueChange event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventDay: event.newEventDay));
    emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
  }

  void _addNewEventDayToEvent(AddNewEventDay event, Emitter<EventsState> emit) {
    if (state.newEventDay != "") {
      EventDay eventDay =
          EventDay(dayOfEvent: state.newEventDay, eventElements: []);
      List<EventDay> eventDays = [];
      eventDays.addAll(state.newEventDays);
      for (EventDay day in eventDays) {
        if (day.dayOfEvent == eventDay.dayOfEvent) {
          return;
        }
      }
      eventDays.add(eventDay);
      eventDays.sort((a, b) => a.dayOfEvent!.compareTo(b.dayOfEvent!));
      emit(state.copyWith(newEventDays: eventDays, newEventDay: ''));
      emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
    }
  }

  void _deleteNewEventDay(DeleteNewEventDay event, Emitter<EventsState> emit) {
    List<EventDay> eventDays = [];
    eventDays.addAll(state.newEventDays);
    eventDays.remove(event.eventDayToDelete);
    emit(state.copyWith(newEventDays: eventDays));
    emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
  }

  void _addNewEventElement(
      AddNewEventElement event, Emitter<EventsState> emit) {
    for (EventDay eventDay in state.newEventDays) {
      if (eventDay == event.eventDay) {
        List<EventElement> eventElements = [];
        EventDay newEventDay;
        eventElements.addAll(eventDay.eventElements);
        eventElements.add(EventElement(
            title: event.title, hour: event.hour, participants: []));
        eventElements.sort((a, b) => a.hour!.compareTo(b.hour!));
        newEventDay = eventDay.copyWith(eventElements: eventElements);
        List<EventDay> newEventDays = [];
        newEventDays.addAll(state.newEventDays);
        newEventDays.remove(eventDay);
        newEventDays.add(newEventDay);
        newEventDays.sort((a, b) => a.dayOfEvent!.compareTo(b.dayOfEvent!));
        emit(state.copyWith(newEventDays: newEventDays));
        emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
        break;
      }
    }
  }

  void _deleteNewEventElement(
      DeleteNewEventElement event, Emitter<EventsState> emit) {
    for (EventDay eventDay in state.newEventDays) {
      if (eventDay == event.eventDay) {
        List<EventElement> eventElements = [];
        List<EventDay> newEventDays = [];
        EventDay newEventDay;
        eventElements.addAll(eventDay.eventElements);
        eventElements.remove(event.eventElement);
        newEventDay = eventDay.copyWith(eventElements: eventElements);
        newEventDays.addAll(state.newEventDays);
        newEventDays.remove(eventDay);
        newEventDays.add(newEventDay);
        newEventDays.sort((a, b) => a.dayOfEvent!.compareTo(b.dayOfEvent!));
        emit(state.copyWith(newEventDays: newEventDays));
        emit(state.copyWith(isNewPostReadyToSubmit: isNewPostReadyToSubmit()));
        break;
      }
    }
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
    for (EventDay eventDay in state.newEventDays) {
      if (eventDay.eventElements.length < 1) {
        return false;
      }
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
      events.sort((a, b) => DateFormat('dd-MM')
          .parse(a.eventDays[0].dayOfEvent.substring(0, 5))!
          .compareTo(DateFormat('dd-MM')
          .parse(b.eventDays[0].dayOfEvent.substring(0, 5))!));
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

  Future<void> _eventDelete(DeleteEvent event, Emitter<EventsState> emit) async {
    try {
      await _eventsRepository.deleteEvent(event.eventToDelete);
      List<Event> events = [];
      events.addAll(state.events);
      events.remove(event.eventToDelete);
      emit(state.copyWith(events: events, eventDeleted: FormzStatus.submissionSuccess));
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
