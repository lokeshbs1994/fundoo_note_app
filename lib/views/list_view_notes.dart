import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/database_manager.dart';
import 'package:instagram_flutter/resources/note_service.dart';
import 'package:instagram_flutter/resources/sqlflite_manager.dart';
import 'package:instagram_flutter/screens/editNote.dart';
import 'package:instagram_flutter/views/note_view.dart';

import '../model/note.dart';

class ListViewNotes extends StatefulWidget {
  const ListViewNotes({Key? key}) : super(key: key);

  @override
  State<ListViewNotes> createState() => _ListViewNotesState();
}

class _ListViewNotesState extends State<ListViewNotes> {
  final scrollController = ScrollController();
  List<Note> allNotes = [];
  bool isLoading = false;
  @override
  void initState() {
    fetchNotes();
    scrollController.addListener(scrollListener);
    super.initState();
  }

  handleNotesCallback(List<Note> newFetchedNotes) {
    setState(() {
      allNotes = newFetchedNotes;
      log("${allNotes.length}");
    });
  }

  fetchNotes() {
    DatabaseManager.getInstance()
        .configureFirebaseListener(handleNotesCallback);
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !isLoading) {
      isLoading = true;
      log("scroll");
      final notes = await DatabaseManager.getInstance().fetchMoreNotes();

      if (notes != null) {
        setState(() {
          allNotes.addAll(notes);
          log("${allNotes.length}");
        });
      }
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: allNotes.length,
      itemBuilder: (context, index) {
        final Note note = allNotes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditNote(
                  note: allNotes[index],
                ),
              ),
            );
          },
          child: NoteView(
            note: note,
          ),
        );
      },
    );
  }
}
