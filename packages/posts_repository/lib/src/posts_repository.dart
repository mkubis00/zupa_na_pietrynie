import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:uuid/uuid.dart';
import '';
import 'exceptions/exceptions.dart';

class PostsRepository {
  PostsRepository({
    FirebaseStorage? firebaseStorage,
    required AuthenticationRepository authenticationRepository,
    FirebaseFirestore? firebaseFirestore,
  })  : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _authenticationRepository = authenticationRepository,
        _firebaseFirestore = FirebaseFirestore.instance;

  late final FirebaseStorage _firebaseStorage;
  late final FirebaseFirestore _firebaseFirestore;
  final AuthenticationRepository _authenticationRepository;

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
    } on FirebaseException catch (e)  {
      throw FireStoreException.fromCode(e.code);
    } catch (_) {
      throw const FireStoreException();
    }
  }
}
