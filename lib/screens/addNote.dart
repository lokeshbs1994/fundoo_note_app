import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/resources/database_manager.dart';
import 'package:instagram_flutter/resources/note_service.dart';
import 'package:instagram_flutter/resources/sqlflite_manager.dart';
import 'package:instagram_flutter/screens/notes_screen.dart';

import '../model/note.dart';
import '../utils/utils.dart';

class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController title = TextEditingController();

  final TextEditingController content = TextEditingController();

  void addNotes() async {
    Note note = Note(
      id: '',
      title: title.text,
      content: content.text,
      createdAt: DateTime.now(),
    );
    Note? addedNote = await DatabaseManager.getInstance().addNote(note: note);

    if (addedNote == null) {
      showSnackBar("not Added", context);
    } else {
      List<Map<String, dynamic>> notess =
          await SqlFliteManager.getInstance().readAllNotes();

      print(notess);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        FlatButton(
          onPressed: addNotes,
          child: Text('Save'),
        ),
      ]),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: TextField(
              controller: title,
              decoration: InputDecoration(hintText: 'Title'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: content,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(hintText: 'Content'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
