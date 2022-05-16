import 'dart:developer';

import 'package:instagram_flutter/model/note.dart';
import 'package:instagram_flutter/resources/note_service.dart';
import 'package:instagram_flutter/resources/sqlflite_manager.dart';

class DatabaseManager {
  DatabaseManager._internal();
  static final DatabaseManager _singleton = DatabaseManager._internal();
  //factory SqlFliteManager() => _singleton;
  static DatabaseManager getInstance() => _singleton;

  final NoteService noteService = NoteService.getInstance();

  final SqlFliteManager sqlFliteManager = SqlFliteManager.getInstance();

  Future<Note?> addNote({
    required Note note,
  }) async {
    Note? addedNote = await noteService.addNote(note: note);
    if (addedNote != null) {
      await sqlFliteManager.insertNewNote(note: addedNote);
    }

    return addedNote;
  }

  Future<String> updateNotes(
      {required String id,
      required String title,
      required String content}) async {
    String res =
        await noteService.updateNotes(id: id, title: title, content: content);
    await sqlFliteManager.update(id: id, title: title, content: content);

    return res;
  }

  Future<void> delete(String id) async {
    noteService.delete(id);
    sqlFliteManager.delete(id);

    return;
  }

  Future<List<Note>> getAllNotes() async {
    return noteService.getAllNotes();
  }

  void configureFirebaseListener(
      Function(List<Note> newFetchedNotes) handleNotesCallback) {
    noteService.configureFirebaseListener(handleNotesCallback);
  }

  Future<List<Note>?> fetchMoreNotes() {
    return noteService.fetchMoreNotes();
  }

  archNote(Note note) {
    noteService.archNote(note);
    sqlFliteManager.archNote(note);
  }

  void archivedNotes(Function(List<Note> newFetchedNotes) handleNotesCallback) {
    noteService.archivedNotes(handleNotesCallback);
  }
}
