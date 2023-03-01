import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostsRepository {
  PostsRepository({
    FirebaseStorage? firebaseStorage,
    required AuthenticationRepository authenticationRepository,
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
  _authenticationRepository = authenticationRepository,
        _firebaseFirestore = FirebaseFirestore.instance;

  late final FirebaseStorage _firebaseStorage;
  late final FirebaseFirestore _firebaseFirestore;
  final AuthenticationRepository _authenticationRepository;

  Future<int> getNumberOfPosts() async {
    await _firebaseFirestore.collection("posts").orderBy("creationDate").startAt([10]);
      return 1;
  }
}