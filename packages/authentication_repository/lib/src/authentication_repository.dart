import 'dart:async';
import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
    FirebaseStorage? firebaseStorage,
    FirebaseFirestore? firebaseFirestore,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _facebookAuth = FacebookAuth.instance,
        _firebaseStorage = FirebaseStorage.instance,
        _firebaseFirestore = FirebaseFirestore.instance;

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  @visibleForTesting
  bool isWeb = kIsWeb;

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';


  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firebaseAuth.currentUser?.sendEmailVerification();
      String? name = currentUser.email;
      await _firebaseAuth.currentUser?.updateDisplayName(name?.split('@')[0]);
      await _firebaseFirestore
          .collection("users")
          .doc(currentUser.id)
          .set(currentUser.toJsonUserInit());
      await logOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<String> getProvider() async {
    try {
      return await _firebaseAuth.currentUser!.providerData[0].providerId;
    } catch (_) {
      return 'empty';
    }
  }

  Future<bool> isAdmin() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await _firebaseFirestore
          .collection('users')
          .doc(currentUser.id)
          .get();
      return documentSnapshot.get('isAdmin');
    } catch (_) {
      return false;
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }
      await _firebaseAuth.signInWithCredential(credential);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firebaseFirestore
              .collection('users')
              .doc(currentUser.id)
              .get();
      if (documentSnapshot.exists) {
        verifyDatabaseUser(documentSnapshot);
      }
      if (!documentSnapshot.exists) {
        _firebaseFirestore
            .collection("users")
            .doc(currentUser.id)
            .set(currentUser.toJsonUserInit());
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  void verifyDatabaseUser(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    documentSnapshot.get('email') != currentUser.email
        ? _firebaseFirestore
            .collection("users")
            .doc(currentUser.id)
            .update({'email': currentUser.email})
        : null;
    documentSnapshot.get('name') != currentUser.name
        ? _firebaseFirestore
            .collection("users")
            .doc(currentUser.id)
            .update({'name': currentUser.name})
        : null;
    documentSnapshot.get('photo') != currentUser.photo
        ? _firebaseFirestore
            .collection("users")
            .doc(currentUser.id)
            .update({'photo': currentUser.photo})
        : null;
  }

  Future<void> logInWithFacebook() async {
    try {
      late final firebase_auth.AuthCredential credential;
      final LoginResult loginResult = await _facebookAuth.login();
      final test = loginResult.accessToken?.token;
      if (test != null) {
        credential = firebase_auth.FacebookAuthProvider.credential(test);
      }
      await _firebaseAuth.signInWithCredential(credential);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firebaseFirestore
              .collection('users')
              .doc(currentUser.id)
              .get();
      if (documentSnapshot.exists) {
        verifyDatabaseUser(documentSnapshot);
      }
      if (!documentSnapshot.exists) {
        _firebaseFirestore
            .collection("users")
            .doc(currentUser.id)
            .set(currentUser.toJsonUserInit());
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithFacebookFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithFacebookFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (await !_firebaseAuth.currentUser!.emailVerified) {
        logOut();
        throw firebase_auth.FirebaseAuthException(
            code: 'user-email-not-verified');
      }
      // DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      //     await _firebaseFirestore
      //         .collection('users')
      //         .doc(currentUser.id)
      //         .get();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> passwordReset({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw PasswordResetFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> updateUserName({required String name}) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(name);
      await _firebaseFirestore
          .collection("users")
          .doc(currentUser.id)
          .update({'name': name});
    } catch (_) {
      throw const UpdateUserCredentialsFailure();
    }
  }

  Future<void> updateUserEmail({required String email}) async {
    try {
      await _firebaseAuth.currentUser?.reload();
      await _firebaseAuth.currentUser?.updateEmail(email);
      await _firebaseFirestore
          .collection("users")
          .doc(currentUser.id)
          .update({'email': email});
    } on firebase_auth.FirebaseException catch (e) {
      throw UpdateUserCredentialsFailure.fromCode(e.code);
    } catch (_) {
      throw const UpdateUserCredentialsFailure();
    }
  }

  Future<void> deleteAccount() async {

    try {
      await _firebaseFirestore.collection("users").doc(currentUser.id).delete();
      await _firebaseStorage.refFromURL(currentUser.photo!).delete();
      await _firebaseAuth.currentUser?.delete();
    } catch (_) {
      //obsga wyjatku
    }


  }

  Future<void> updateUserPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    try {
      if (result != null) {
        final file = File(result.files.first!.path!);
        final id = currentUser.id;
        final path = "usersProfilePhoto/$id";
        await _firebaseStorage.ref().child(path).putFile(file);
        final fileRef = await _firebaseStorage.ref(path).getDownloadURL();
        await _firebaseAuth.currentUser?.updatePhotoURL(fileRef);
      }
    } catch (_) {
      throw const UpdateUserCredentialsFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _facebookAuth.logOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
