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
  }


  final EventsRepository _eventsRepository;

  void _onEventTitleChange(NewEventTitleChangeEvent event, Emitter<EventsState> emit) {
      emit(state.copyWith(newEventTitle: event.newTitle));
  }

  void _onEventDescriptionChange(NewEventDescriptionChangeEvent event, Emitter<EventsState> emit) {
      emit(state.copyWith(newEventDescription: event.newDescription));
  }

  void _onEventPublishDateChange(NewEventPublishDateChangeEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventPublishDate: event.newPublishDate));
  }

  void _onNewEventValueChange(NewEventDayValueChange event, Emitter<EventsState> emit) {
    emit(state.copyWith(newEventDay: event.newEventDay));
  }

  void _addNewEventDayToEvent(AddNewEventDay event, Emitter<EventsState> emit) {
    if (state.newEventDay != "") {
      EventDay eventDay = EventDay(dayOfEvent: state.newEventDay, eventElements: []);
      List<EventDay> eventDays = [];
      eventDays.addAll(state.newEventDays);
      for(EventDay day in eventDays) {
        if (day.dayOfEvent == eventDay.dayOfEvent) {
          return;
        }
      }
      eventDays.add(eventDay);
      eventDays.sort((a, b) => a.dayOfEvent!.compareTo(b.dayOfEvent!));
      emit(state.copyWith(newEventDays: eventDays, newEventDay: ''));
    }
  }

  void _deleteNewEventDay(DeleteNewEventDay event,  Emitter<EventsState> emit) {
    List<EventDay> eventDays = [];
    eventDays.addAll(state.newEventDays);
    eventDays.remove(event.eventDayToDelete);
    emit(state.copyWith(newEventDays: eventDays));
  }
}
