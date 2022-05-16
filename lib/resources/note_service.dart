import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/model/note.dart';

class NoteService {
  NoteService._internal();
  static final NoteService _singleton = NoteService._internal();
  //factory SqlFliteManager() => _singleton;
  static NoteService getInstance() => _singleton;

  static QueryDocumentSnapshot? lastDocument;
  static int documentLimit = 10;
  static bool _hasNext = true;

  static final CollectionReference _ref =
      FirebaseFirestore.instance.collection('notes');

  bool get hasNext => _hasNext;

  Future<Note?> addNote({
    required Note note,
    // required String title,
    // required String content,
    //DateTime? dateTime,
  }) async {
    String res = 'Some error occured';
    try {
      DocumentReference doc = _ref.doc();
      note.id = doc.id;

      doc.set(note.toJson());

      return note;
    } catch (err) {
      res = err.toString();
    }
    return null;
  }

  Future<String> updateNotes({
    required String id,
    required String title,
    required String content, //DateTime? dateTime
  }) async {
    String res = 'Some error occured';
    try {
      if (title.isNotEmpty && content.isNotEmpty) {
        await _ref.doc(id).update({
          'title': title,
          'content': content,
        }); //'dateTime': dateTime
        res = "success";
      } else {
        res = "Enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> delete(String id) async {
    return await _ref.doc(id).delete();
  }

  Future<List<Note>> getAllNotes() async {
    QuerySnapshot snapshot = await _ref.get();
    final allNotes = snapshot.docs.map((doc) => Note.fromJson(doc)).toList();
    return allNotes;
  }

  configureFirebaseListener(Function(List<Note>) handleNotesCallback) {
    log('1st fetch');
    _ref
        .where('isArchive', isEqualTo: false)
        .orderBy('createdAt')
        .limit(documentLimit)
        .snapshots()
        .listen((snapshot) {
      _hasNext = true;
      lastDocument = snapshot.docs.last;
      if (snapshot.docs.length < documentLimit) _hasNext = false;
      final allNotes = snapshot.docs.map((doc) => Note.fromJson(doc)).toList();
      handleNotesCallback(allNotes);
    });
  }

  Future<List<Note>?> fetchMoreNotes() async {
    if (!_hasNext) {
      return null;
    }
    log("2nd ");

    if (lastDocument != null) {
      final snapShot = await _ref
          .where('isArchive', isEqualTo: false)
          .orderBy('createdAt')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();

      lastDocument = snapShot.docs.last;
      if (snapShot.docs.length < documentLimit) _hasNext = false;
      final allNotes = snapShot.docs.map((doc) => Note.fromJson(doc)).toList();
      return allNotes;
    }
    return null;
  }

  Future<String> archNote(Note note) async {
    String res = 'Some error occured';
    try {
      if (note.title.isNotEmpty && note.content.isNotEmpty) {
        await _ref.doc(note.id).update({
          'isArchive': !note.isArchive,
        }); //'dateTime': dateTime
        res = "success";
      } else {
        res = "Enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  archivedNotes(Function(List<Note>) handleNotesCallback) {
    _ref
        .where('isArchive', isEqualTo: true)
        .orderBy('createdAt')
        .limit(documentLimit)
        .snapshots()
        .listen((snapshot) {
      final archivedNotes =
          snapshot.docs.map((doc) => Note.fromJson(doc)).toList();
      handleNotesCallback(archivedNotes);
    });
  }
}
