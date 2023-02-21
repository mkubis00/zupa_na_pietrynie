import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class PostRepository {
  PostRepository({
    FirebaseStorage? firebaseStorage,
    AuthenticationRepository? authenticationRepository,
  }) : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
  _authenticationRepository = authenticationRepository ?? AuthenticationRepository();

  final FirebaseStorage _firebaseStorage;
  final AuthenticationRepository _authenticationRepository;
}