import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:posts_repository/posts_repository.dart';

class PostsRepository {
  PostsRepository({
    FirebaseStorage? firebaseStorage,
    required AuthenticationRepository authenticationRepository,
    FirebaseFirestore? firebaseFirestore,
  })  : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _authenticationRepository = authenticationRepository,
        _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;
  final AuthenticationRepository _authenticationRepository;

  late QueryDocumentSnapshot<Object?> postSnapshot;

  Future<void> createNewPost(List<File?> photos, String content) async {
    String uuid = const Uuid().v1();
    List<String> photosPaths = [];
    DateTime postCreationDate = DateTime.now();
    try {
      for (File? photo in photos) {
        int? index = photo?.path.lastIndexOf("/");
        String? name = photo?.path.substring(index! + 1);
        await _firebaseStorage.ref().child("posts/$uuid/$name").putFile(photo!);
        final String path =
            await _firebaseStorage.ref("posts/$uuid/$name").getDownloadURL();
        photosPaths.add(path);
      }
      final newPost = <String, dynamic>{
        "id": uuid,
        "ownerId": _authenticationRepository.currentUser.id,
        "creationDate": postCreationDate.toString(),
        "postContent": content,
        "postPhotos": photosPaths,
      };
      await _firebaseFirestore.collection("posts").doc(uuid).set(newPost);
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<int> eventsCounterFetch() async {
    try {
      QuerySnapshot<Map<String, dynamic>> test =
          await _firebaseFirestore.collection("events_counter").limit(1).get();
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          test.docs.elementAt(0);
      return documentSnapshot.get('count');
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<List<Post>> postFetch(bool fromBeginning) async {
    List<Post> fetchedPosts = [];
    if (!fromBeginning) {
      await _firebaseFirestore
          .collection('posts')
          .orderBy('creationDate', descending: true)
          .limit(10)
          .startAfterDocument(postSnapshot)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          fetchedPosts.add(Post(
              ownerId: doc['ownerId'],
              creationDate: doc['creationDate'],
              postContent: doc['postContent'],
              id: doc['id'],
              postPhotos: List<String>.from(doc['postPhotos'] as List)));
        });
        querySnapshot.size > 0 ? postSnapshot = querySnapshot.docs.last : null;
      });
    } else {
      await _firebaseFirestore
          .collection('posts')
          .orderBy('creationDate', descending: true)
          .limit(10)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          fetchedPosts.add(Post(
              ownerId: doc['ownerId'],
              creationDate: doc['creationDate'],
              postContent: doc['postContent'],
              id: doc['id'],
              postPhotos: List<String>.from(doc['postPhotos'] as List)));
        });
        postSnapshot = querySnapshot.docs.last;
      });
    }
    return fetchedPosts;
  }

  Future<Set<UserToPost>> getUserstoPosts(List<Post> posts) async {
    Set<String> ids = {};
    posts.forEach((element) {
      ids.add(element.ownerId);
    });
    Set<UserToPost> usersToPosts = {};
    try {
      for (String id in ids) {
        await _firebaseFirestore
            .collection('users')
            .doc(id)
            .get()
            .then((document) {
          usersToPosts.add(UserToPost(
              id: document.get('id'),
              name: document.get('name'),
              photo: document.get('photo')));
        }).catchError((error) {
        });
      }
      return usersToPosts;
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<void> deletePost(String postId, String ownerId) async {
    try {
      bool isAdmin = await _authenticationRepository.isAdmin();
      if (isAdmin == true ||
          _authenticationRepository.currentUser.id == ownerId) {
        await _firebaseFirestore.collection('posts').doc(postId).delete();
      } else {
        throw const FireStoreException();
      }
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<void> updatePost(Post post) async {
    try {
      bool isAdmin = await _authenticationRepository.isAdmin();
      if (isAdmin == true ||
          _authenticationRepository.currentUser.id == post.ownerId) {
        final updatePost = <String, dynamic>{
          "id": post.id,
          "ownerId": post.ownerId,
          "creationDate": post.creationDate,
          "postContent": post.postContent,
          "postPhotos": post.postPhotos,
        };
        await _firebaseFirestore
            .collection('posts')
            .doc(post.id)
            .set(updatePost);
      }
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }
}
