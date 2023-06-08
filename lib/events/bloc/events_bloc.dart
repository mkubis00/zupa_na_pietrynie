import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:events_repository/events_repository.dart';

part 'events_event.dart';

part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(this._eventsRepository) : super(const EventsState()) {
    on<NewEventTitleChangeEvent>(_onNewEventTitleChangeEvent);
    on<NewEventDescriptionChangeEvent>(_onNewEventDescriptionChangeEvent);
    on<NewEventPublishDateChangeEvent>(_onNewEventPublishDateChangeEvent);
    on<NewEventDayAddEvent>(_onNewEventDayAddEvent);
    on<NewEventDayDeleteEvent>(_onNewEventDayDeleteEvent);
    on<NewEventElementDeleteEvent>(_onNewEventElementDeleteEvent);
    on<NewEventCreateEvent>(_onNewEventCreateEvent);
    on<NewEventDayChangeEvent>(_onNewEventDayChangeEvent);
    on<NewEventElementTitleChangeEvent>(_onNewEventElementTitleChangeEvent);
    on<NewEventElementHourChangeEvent>(_onNewEventElementHourChangeEvent);
    on<EventsFetchEvent>(_onEventsFetchEvent);
    on<EventElementParticipationChangeEvent>(
        _onEventElementParticipationChangeEvent);
    on<EventDeleteEvent>(_onDeleteEventEvent);
    on<EventElementToNewEventDayAddEvent>(_onEventElementToNewEventDayAddEvent);
    on<_EventElementUpdateStreamEvent>(_onEventElementUpdateStreamEvent);
    on<_IsEventDayReadyEvent>(_onIsEventDayReadyEvent);
    on<_IsEventReadyToSubmitEvent>(_onIsEventReadyToSubmitEvent);
    _eventRepositorySubscription =
        _eventsRepository.eventElement.listen(cancelOnError: false, (event) {
      add(_EventElementUpdateStreamEvent(event));
    });
  }

  final EventsRepository _eventsRepository;
  late final StreamSubscription<EventElement> _eventRepositorySubscription;

  Future<void> _onEventElementUpdateStreamEvent(
      _EventElementUpdateStreamEvent event, Emitter<EventsState> emit) async {
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
              _sortHours(newEventElements);
              isEventElementChanged = true;
              break;
            }
          }
          if (isEventElementChanged) {
            newEventDays.addAll(eventInEvents.eventDays);
            newEventDays
                .add(eventDay.copyWith(eventElements: newEventElements));
            newEventDays.remove(eventDay);
            _sortDays(newEventDays);
            break;
          }
        }
        if (isEventElementChanged) {
          events.insert(0, eventInEvents.copyWith(eventDays: newEventDays));
          events.remove(eventInEvents);
          _sortEvents(events);
          break;
        }
      }
      emit(state.copyWith(events: events));
    } catch (_) {}
  }

  void _onIsEventDayReadyEvent(
      _IsEventDayReadyEvent event, Emitter<EventsState> emit) {
    bool isReady = true;
    if (state.eventDayToCreate.dayOfEvent == '') isReady = false;
    if (state.eventDayToCreate.eventElements.length == 0) isReady = false;
    emit(state.copyWith(isEventDayReady: isReady));
  }

  void _onIsEventReadyToSubmitEvent(
      _IsEventReadyToSubmitEvent event, Emitter<EventsState> emit) {
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

  void _onEventElementToNewEventDayAddEvent(
      EventElementToNewEventDayAddEvent event, Emitter<EventsState> emit) {
    List<EventElement> updatedEventElements = [];
    updatedEventElements.addAll(state.eventDayToCreate.eventElements);
    updatedEventElements.add(EventElement(
        title: state.newEventElementTitle,
        hour: state.newEventElementHour,
        participants: const []));
    _sortHours(updatedEventElements);
    emit(state.copyWith(
        eventDayToCreate: state.eventDayToCreate
            .copyWith(eventElements: updatedEventElements),
        newEventElementHour: '',
        newEventElementTitle: ''));
    add(_IsEventDayReadyEvent());
  }

  void _onNewEventDayChangeEvent(
      NewEventDayChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(
        eventDayToCreate:
            state.eventDayToCreate.copyWith(dayOfEvent: event.dayOfEvent)));
    add(_IsEventDayReadyEvent());
  }

  void _onNewEventElementTitleChangeEvent(
      NewEventElementTitleChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventElementTitle: event.newEventElementTitle));
  }

  void _onNewEventElementHourChangeEvent(
      NewEventElementHourChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventElementHour: event.dateTime));
  }

  void _onNewEventTitleChangeEvent(
      NewEventTitleChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventTitle: event.newTitle));
    add(_IsEventReadyToSubmitEvent());
  }

  void _onNewEventDescriptionChangeEvent(
      NewEventDescriptionChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventDescription: event.newDescription));
    add(_IsEventReadyToSubmitEvent());
  }

  void _onNewEventPublishDateChangeEvent(
      NewEventPublishDateChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventPublishDate: event.newPublishDate));
    add(_IsEventReadyToSubmitEvent());
  }
//tutaj skonczone
  void _onNewEventDayAddEvent(
      NewEventDayAddEvent event, Emitter<EventsState> emit) {
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
      _sortDays(eventDays);
      emit(state.copyWith(
          newEventDays: eventDays,
          eventDayToCreate: EventDay(dayOfEvent: '', eventElements: [])));
      emit(state.copyWith(isEventDayReady: false));
      add(_IsEventReadyToSubmitEvent());
    }
  }

  void _onNewEventDayDeleteEvent(
      NewEventDayDeleteEvent event, Emitter<EventsState> emit) {
    List<EventDay> eventDays = [];
    eventDays.addAll(state.newEventDays);
    eventDays.remove(event.eventDayToDelete);
    emit(state.copyWith(newEventDays: eventDays));
    add(_IsEventReadyToSubmitEvent());
  }

  void _onNewEventElementDeleteEvent(
      NewEventElementDeleteEvent event, Emitter<EventsState> emit) {
    List<EventElement> eventElements = [];
    eventElements.addAll(state.eventDayToCreate.eventElements);
    eventElements.remove(event.eventElement);
    emit(state.copyWith(
        eventDayToCreate:
            state.eventDayToCreate.copyWith(eventElements: eventElements)));
    add(_IsEventDayReadyEvent());
    add(_IsEventReadyToSubmitEvent());
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

  Future<void> _onNewEventCreateEvent(
      NewEventCreateEvent event, Emitter<EventsState> emit) async {
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
      _sortEvents(events);
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

  Future<void> _onEventsFetchEvent(
      EventsFetchEvent event, Emitter<EventsState> emit) async {
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

  Future<void> _onEventElementParticipationChangeEvent(
      EventElementParticipationChangeEvent event,
      Emitter<EventsState> emit) async {
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

  Future<void> _onDeleteEventEvent(
      EventDeleteEvent event, Emitter<EventsState> emit) async {
    try {
      await _eventsRepository.deleteEvent(event.eventToDelete);
      List<Event> events = [];
      events.addAll(state.events);
      events.remove(event.eventToDelete);
      emit(state.copyWith(
          events: events, eventDeletedStatus: FormzStatus.submissionSuccess));
    } on FireStoreException catch (e) {
      emit(state.copyWith(eventDeletedStatus: FormzStatus.submissionFailure));
    } catch (_) {
      emit(state.copyWith(eventDeletedStatus: FormzStatus.submissionFailure));
    } finally {
      emit(state.copyWith(eventDeletedStatus: FormzStatus.pure));
    }
  }

  void _sortHours(List<EventElement> listToSort) {
    listToSort.sort((a, b) => DateFormat('HH:mm')
        .parse(a.hour)
        .compareTo(DateFormat('HH:mm').parse(b.hour)));
  }

  void _sortDays(List<EventDay> listToSort) {
    listToSort.sort((a, b) => DateFormat('dd/MM/yy')
        .parse(a.dayOfEvent.substring(0, 8))!
        .compareTo(DateFormat('dd/MM/yy')
        .parse(b.dayOfEvent.substring(0, 8)!)));
  }

  void _sortEvents(List<Event> listToSort) {
    listToSort.sort((a, b) => DateFormat('dd/MM/yy')
        .parse(a.eventDays[0].dayOfEvent.substring(0, 8))!
        .compareTo(DateFormat('dd/MM/yy')
        .parse(b.eventDays[0].dayOfEvent.substring(0, 8))!));
  }

  @override
  Future<void> close() {
    _eventRepositorySubscription.cancel();
    return super.close();
  }
}
