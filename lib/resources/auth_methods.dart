import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/model/user.dart' as model;
import 'package:instagram_flutter/model/note.dart' as model;

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // signup user
  static Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = "Some error occurred";
    log('before if');
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        // register user
        log('Inside if');
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final uid = cred.user!.uid;
        log(uid);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //add user to our database

        model.User user = model.User(
          username: username,
          uid: uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
        );

        await _firestore.collection('users').doc(uid).set(user.toJson());
        // await _firestore.collection('users').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        // });
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// logging in user
  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occoured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Successs';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<bool> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      return false;
    }
    return true;
  }

  static Future<model.User> getUser() async {
    final uid = _auth.currentUser?.uid;

    final userDocument = await _firestore.collection('users').doc(uid).get();
    final user = model.User.fromJson(userDocument);
    return user;
  }
}
