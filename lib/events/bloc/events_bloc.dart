import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:events_repository/events_repository.dart';
import 'package:formz/formz.dart';

part 'events_event.dart';

part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(this._eventsRepository) : super(EventsState()) {
    on<NewEventTitleChangeEvent>(_onEventTitleChange);
    on<NewEventDescriptionChangeEvent>(_onEventDescriptionChange);
    on<NewEventPublishDateChangeEvent>(_onEventPublishDateChange);
    on<NewEventDayValueChange>(_onNewEventValueChange);
    on<AddNewEventDay>(_addNewEventDayToEvent);
    on<DeleteNewEventDay>(_deleteNewEventDay);
    on<AddNewEventElement>(_addNewEventElement);
    on<DeleteNewEventElement>(_deleteNewEventElement);
    on<NewEventCreate>(_eventCreate);
  }

  final EventsRepository _eventsRepository;

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
      await _eventsRepository.createNewEvent(newEvent);
      emit(state.copyWith(
          newEventStatus: FormzStatus.submissionSuccess,
          newEventTitle: '',
          newEventDescription: '',
          newEventPublishDate: '',
          newEventDays: []));
    } catch (_) {
      emit(state.copyWith(newEventStatus: FormzStatus.submissionFailure));
    } finally {
      emit(state.copyWith(newEventStatus: FormzStatus.pure));
    }
  }
}
