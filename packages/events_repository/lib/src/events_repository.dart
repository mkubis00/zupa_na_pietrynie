import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_repository/events_repository.dart';
import 'package:uuid/uuid.dart';

class EventsRepository {
  EventsRepository({
    required AuthenticationRepository authenticationRepository,
    FirebaseFirestore? firebaseFirestore,
  })  : _authenticationRepository = authenticationRepository,
        _firebaseFirestore = FirebaseFirestore.instance;

  final AuthenticationRepository _authenticationRepository;
  final FirebaseFirestore _firebaseFirestore;

  Future<void> createNewEvent(Event event) async {
    try {
      if (await _authenticationRepository.isAdmin()) {
      String eventUuid = const Uuid().v1();
      final newEventToDb = <String, dynamic>{
        'id': eventUuid,
        'title': event.title,
        'description': event.description,
        'publishDate': event.publishDate
      };
      await _firebaseFirestore
          .collection('events')
          .doc(eventUuid)
          .set(newEventToDb);
      for (EventDay eventDay in event.eventDays) {
        String eventDayUuid = const Uuid().v1();
        final eventDayToDb = <String, dynamic>{
          'id': eventDayUuid,
          'eventId': eventUuid,
          'dayOfEvent': eventDay.dayOfEvent,
        };
        await _firebaseFirestore
            .collection('events_days')
            .doc(eventDayUuid)
            .set(eventDayToDb);
        for (EventElement eventElement in eventDay.eventElements) {
          String eventElementUuid = const Uuid().v1();
          final eventElementToDb = <String, dynamic>{
            'id': eventElementUuid,
            'eventDayId': eventDayUuid,
            'title': eventElement.title,
            'hour': eventElement.hour,
            'participants': []
          };
          await _firebaseFirestore
              .collection('events_elements')
              .doc(eventElementUuid)
              .set(eventElementToDb);
        }
      }}
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }
}
