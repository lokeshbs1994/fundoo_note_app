import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/note.dart';
import 'package:instagram_flutter/resources/database_manager.dart';
import 'package:instagram_flutter/screens/editNote.dart';
import 'package:instagram_flutter/views/note_view.dart';

import '../model/user.dart';
import '../resources/auth_methods.dart';
import 'navigationdrawer.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  User? user;
  List<Note> archivedNotes = [];

  @override
  void initState() {
    archivedNotes.clear;
    fetchArchivedNotes();
    getUser();
    super.initState();
  }

  getUser() async {
    user = await AuthMethods.getUser();
    setState(() {});
  }

  handleNotesCallback(List<Note> newFetchedNotes) {
    setState(() {
      archivedNotes = newFetchedNotes;
      log("${archivedNotes.length}");
    });
  }

  fetchArchivedNotes() {
    DatabaseManager.getInstance().archivedNotes(handleNotesCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white10,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Material(
                color: Colors.white10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Archived Notes",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: NavigationDrawer(
        user: user,
      ),
      body: ListView.builder(
        itemCount: archivedNotes.length,
        itemBuilder: (context, index) {
          final Note note = archivedNotes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNote(
                    note: archivedNotes[index],
                  ),
                ),
              );
            },
            child: NoteView(
              note: note,
            ),
          );
        },
      ),
    );
  }
}
