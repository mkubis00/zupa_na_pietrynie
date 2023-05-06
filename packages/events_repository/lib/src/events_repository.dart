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
        }
      }
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<List<Event>> fetchEvents() async {
    try {
      List<Event> events = [];
      await _firebaseFirestore
          .collection('events')
          .orderBy('publishDate', descending: true)
          .get()
          .then((QuerySnapshot eventSnapshot) {
        eventSnapshot.docs.forEach((eventDoc) async {
          List<EventDay> eventDays = [];
          await _firebaseFirestore
              .collection('events_days')
              .where('eventId', isEqualTo: eventDoc['id'])
              .get()
              .then((QuerySnapshot eventDaySnapshot) {
            eventDaySnapshot.docs.forEach((eventDayDoc) async {
              List<EventElement> eventElements = [];
              await _firebaseFirestore
                  .collection('events_elements')
                  .where('eventDayId', isEqualTo: eventDayDoc['id'])
                  .get()
                  .then((QuerySnapshot eventElementSnapshot) {
                eventElementSnapshot.docs.forEach((eventElementDoc) {
                  eventElements.add(EventElement(
                      id: eventElementDoc['id'],
                      title: eventElementDoc['title'],
                      hour: eventElementDoc['hour'],
                      participants: List<String>.from(eventElementDoc['participants'])));
                });
              });
              eventDays.add(EventDay(
                  id: eventDayDoc['id'],
                  dayOfEvent: eventDayDoc['dayOfEvent'],
                  eventElements: eventElements));
            });
          });
          events.add(Event(
              id: eventDoc['id'],
              title: eventDoc['title'],
              description: eventDoc['description'],
              eventDays: eventDays,
              publishDate: eventDoc['publishDate']));
        });
      });
      return events;
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }
}
