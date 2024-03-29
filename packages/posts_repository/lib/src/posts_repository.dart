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
        _firebaseFirestore = FirebaseFirestore.instance {
    _newPostSubscription = _newPostStream().listen((event) {
      _newPostFromStream(event);
    });
    _postChangeSubscription = _postChangeStream().listen((event) {
      _updatePostFromStream(event.docChanges);
    });
  }

  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;
  final AuthenticationRepository _authenticationRepository;

  late QueryDocumentSnapshot<Object?> postSnapshot;

  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _postChangeSubscription;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _newPostSubscription;

  final StreamController<Post> _controller = StreamController.broadcast();

  Stream<Post> get posts => _controller.stream;

  Stream<QuerySnapshot<Map<String, dynamic>>> _postChangeStream() {
    final docRef = _firebaseFirestore
        .collection('posts')
        .orderBy('creationDate', descending: true)
        .limit(20);
    return docRef.snapshots(includeMetadataChanges: true).handleError( (error){
     return;
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _newPostStream() {
    final docRef = _firebaseFirestore
        .collection("posts")
        .orderBy('creationDate', descending: true)
        .limit(1);
    return docRef.snapshots()
        .handleError( (error){
      return;
    })
  ;
  }

  void _newPostFromStream(QuerySnapshot<Map<String, dynamic>> event) {
    try {
      if (event.docs.length == 1) {
        QueryDocumentSnapshot<Map<String, dynamic>> newPostDoc =
            event.docs.elementAt(0);
        Post newPost = Post(
            id: newPostDoc['id'],
            ownerId: newPostDoc['ownerId'],
            creationDate: newPostDoc['creationDate'],
            postContent: newPostDoc['postContent'],
            postPhotos: List<String>.from(newPostDoc['postPhotos'] as List),
            numberOfComments: newPostDoc['numberOfComments']);
        _controller.sink.add(newPost);
      }
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  void _updatePostFromStream(
      List<DocumentChange<Map<String, dynamic>>> documentChangeList) {
    try {
      if (documentChangeList.length == 1) {
        Map<String, dynamic>? data = documentChangeList.elementAt(0).doc.data();
        Post updatedPost = Post(
            ownerId: data!['ownerId'],
            creationDate: data!['creationDate'],
            postContent: data!['postContent'],
            id: data!['id'],
            postPhotos: List<String>.from(data!['postPhotos'] as List),
            numberOfComments: data!['numberOfComments']);
        _controller.sink.add(updatedPost);
      }
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  User getCurrentUSer() {
    return _authenticationRepository.currentUser;
  }

  Future<Post> createNewPost(List<File?> photos, String content) async {
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
        "numberOfComments": 0
      };
      Post newPostReturn = Post(
          id: uuid,
          ownerId: _authenticationRepository.currentUser.id,
          creationDate: postCreationDate.toString(),
          postContent: content,
          numberOfComments: 0,
          postPhotos: photosPaths);
      await _firebaseFirestore.collection("posts").doc(uuid).set(newPost);
      return newPostReturn;
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<void> createComment(String commentContent, String postId) async {
    try {
      String uuid = const Uuid().v1();
      DateTime commentCreationDate = DateTime.now();
      final newComment = <String, dynamic>{
        "id": uuid,
        "ownerId": _authenticationRepository.currentUser.id,
        "postId": postId,
        "commentContent": commentContent,
        "creationDate": commentCreationDate.toString()
      };
      await _firebaseFirestore.collection("comments").doc(uuid).set(newComment);
      await _firebaseFirestore
          .collection("posts")
          .doc(postId)
          .update({'numberOfComments': FieldValue.increment(1)});
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<void> deleteComment(String id, String ownerId, String postId) async {
    try {
      bool isAdmin = await _authenticationRepository.isAdmin();
      if (isAdmin == true ||
          _authenticationRepository.currentUser.id == ownerId) {
        await _firebaseFirestore.collection("comments").doc(id).delete();
        await _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .update({'numberOfComments': FieldValue.increment(-1)});
      } else {
        throw const FireStoreException();
      }
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<List<Comment>> fetchComments(String postId) async {
    try {
      List<Comment> fetchedComments = [];
      await _firebaseFirestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
          fetchedComments.add(Comment(
            ownerId: doc['ownerId'],
            creationDate: doc['creationDate'],
            commentContent: doc['commentContent'],
            id: doc['id'],
            postId: doc['postId'],
          ));
        }
      });
      fetchedComments
          .sort((a, b) => a.creationDate!.compareTo(b.creationDate!));
      return fetchedComments.reversed.toList();
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
              postPhotos: List<String>.from(doc['postPhotos'] as List),
              numberOfComments: doc['numberOfComments']));
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
              postPhotos: List<String>.from(doc['postPhotos'] as List),
              numberOfComments: doc['numberOfComments']));
        });
        postSnapshot = querySnapshot.docs.last;
      });
    }
    return fetchedPosts;
  }

  Future<Set<UserToPost>> getUsersToPosts(List<dynamic> postsOrComments) async {
    Set<String> usersToPostsIds = {};
    postsOrComments.forEach((element) {
      usersToPostsIds.add(element.ownerId);
    });
    Set<UserToPost> usersToPosts = {};
    usersToPosts.add(UserToPost(
        id: _authenticationRepository.currentUser.id,
        name: _authenticationRepository.currentUser.name!,
        photo: _authenticationRepository.currentUser.photo!));
    try {
      for (String id in usersToPostsIds) {
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
        //usuniecie komentarzy trzeba dodać
      } else {
        throw const FireStoreException();
      }
    } on FirebaseException catch (e) {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }

  Future<void> updatePost(Post post, String newContent) async {
    try {
      bool isAdmin = await _authenticationRepository.isAdmin();
      if (isAdmin == true
          ||
          _authenticationRepository.currentUser.id == post.ownerId
      ) {
        final updatePost = <String, dynamic>{
          "id": post.id,
          "ownerId": post.ownerId,
          "creationDate": post.creationDate,
          "postContent": newContent,
          "postPhotos": post.postPhotos,
          "numberOfComments": post.numberOfComments,
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
