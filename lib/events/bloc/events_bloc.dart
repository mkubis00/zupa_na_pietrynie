import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:events_repository/events_repository.dart';
import 'package:formz/formz.dart';

part 'events_event.dart';

part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(this._eventsRepository) : super(EventsState()) {
    on<EventTitleChangeEvent>(_onEventTitleChange);
    on<EventDescriptionChangeEvent>(_onEventDescriptionChange);
  }


  final EventsRepository _eventsRepository;

  void _onEventTitleChange(EventTitleChangeEvent event, Emitter<EventsState> emit) {
      emit(state.copyWith(newEventTitle: event.newTitle));
  }

  void _onEventDescriptionChange(EventDescriptionChangeEvent event, Emitter<EventsState> emit) {
      emit(state.copyWith(newEventDescription: event.newDescription));
  }

}
