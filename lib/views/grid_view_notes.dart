import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/note_service.dart';
import 'package:instagram_flutter/views/note_view.dart';

import '../model/note.dart';
import '../screens/editNote.dart';

class GridViewNotes extends StatefulWidget {
  const GridViewNotes({Key? key}) : super(key: key);

  @override
  State<GridViewNotes> createState() => _GridViewNotesState();
}

class _GridViewNotesState extends State<GridViewNotes> {
  List<Note> allNotes = [];

  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  handleNotesCallback(List<Note> allNotes) {
    setState(() {
      this.allNotes = allNotes;
    });
  }

  fetchNotes() async {
    NoteService.getInstance().configureFirebaseListener(handleNotesCallback);
  }

  bool view = false;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: view ? 1 : 2),
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
            ));
      },
    );
  }
}
