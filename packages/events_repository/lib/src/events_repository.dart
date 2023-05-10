import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_repository/events_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class EventsRepository {
  EventsRepository({
    required AuthenticationRepository authenticationRepository,
    FirebaseFirestore? firebaseFirestore,
  })
      : _authenticationRepository = authenticationRepository,
        _firebaseFirestore = FirebaseFirestore.instance {
    _newEventElementSubscription = _eventElementChangeStream().listen((event) {
      _newEventElementFromStream(event.docChanges);
    });

  }


  final AuthenticationRepository _authenticationRepository;
  final FirebaseFirestore _firebaseFirestore;

  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
  _newEventElementSubscription;

  final StreamController<EventElement> _controller = StreamController.broadcast();

  Stream<EventElement> get eventElement => _controller.stream;

  Stream<QuerySnapshot<Map<String, dynamic>>> _eventElementChangeStream() {
    final docRef = _firebaseFirestore
        .collection("events_elements");
    return docRef.snapshots(includeMetadataChanges: true);
  }

  void _newEventElementFromStream(List<DocumentChange<Map<String, dynamic>>> documentChangeList) {
    try {
      if (documentChangeList.length == 1) {
        Map<String, dynamic>? data = documentChangeList.elementAt(0).doc.data();
        EventElement updatedEventElement = EventElement(
            id: data!['id'],
            title: data!['title'],
            hour: data!['hour'],
            participants: List<String>.from(data!['participants'] as List),
        );
        _controller.sink.add(updatedEventElement);
      }
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

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
      List<Event> eventsToReturn = [];
      await _firebaseFirestore
          .collection('events')
          .orderBy('publishDate', descending: true)
          .get()
          .then((QuerySnapshot eventSnapshot) {
        eventSnapshot.docs.forEach((eventDoc) async {
          events.add(Event(
              id: eventDoc['id'],
              title: eventDoc['title'],
              description: eventDoc['description'],
              eventDays: const [],
              publishDate: eventDoc['publishDate']));
        });
      });
      for (Event event in events) {
        List<EventDay> eventDays = await _fetchEventDays(event.id!);
        List<EventDay> eventsDayToReturn = [];
        for (EventDay eventDay in eventDays) {
          List<EventElement> eventElements =
          await _fetchEventElement(eventDay.id!);
          eventElements.sort((a, b) =>
              DateFormat('HH:mm')
                  .parse(a.hour)!
                  .compareTo(DateFormat('HH:mm').parse(b.hour)));
          EventDay eventDayWithElements =
          eventDay.copyWith(eventElements: eventElements);
          eventsDayToReturn.add(eventDayWithElements);
        }
        eventsDayToReturn.sort((a, b) =>
            DateFormat('dd-MM')
                .parse(a.dayOfEvent.substring(0, 5))!
                .compareTo(
                DateFormat('dd-MM').parse(b.dayOfEvent.substring(0, 5)!)));
        Event eventWithDays = event.copyWith(eventDays: eventsDayToReturn);
        eventsToReturn.add(eventWithDays);
      }
      eventsToReturn.sort((a, b) =>
          DateFormat('dd-MM')
              .parse(a.eventDays[0].dayOfEvent.substring(0, 5))!
              .compareTo(DateFormat('dd-MM')
              .parse(b.eventDays[0].dayOfEvent.substring(0, 5))!));
      return eventsToReturn;
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<List<EventDay>> _fetchEventDays(String eventId) async {
    List<EventDay> eventDays = [];
    await _firebaseFirestore
        .collection('events_days')
        .where('eventId', isEqualTo: eventId)
        .get()
        .then((QuerySnapshot eventDaySnapshot) {
      eventDaySnapshot.docs.forEach((eventDayDoc) async {
        eventDays.add(EventDay(
            id: eventDayDoc['id'],
            dayOfEvent: eventDayDoc['dayOfEvent'],
            eventElements: const []));
      });
    });
    return eventDays;
  }

  Future<List<EventElement>> _fetchEventElement(String eventDayId) async {
    List<EventElement> eventElements = [];
    await _firebaseFirestore
        .collection('events_elements')
        .where('eventDayId', isEqualTo: eventDayId)
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
    return eventElements;
  }

  User getCurrentUser() {
    return _authenticationRepository.currentUser;
  }

  Future<void> updateEventElementParticipation(String eventElementId,
      List<String> eventElementParticipants) async {
    try {
      await _firebaseFirestore.collection('events_elements')
          .doc(eventElementId)
          .update({'participants': eventElementParticipants});
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      print("TUTAAAAJ");
      throw const FireStoreException();
    }
  }

  void dispose() {

  }

}
