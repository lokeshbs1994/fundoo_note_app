import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagram_flutter/main.dart';
import '../model/note.dart';

class NoteView extends StatefulWidget {
  final Note note;
  const NoteView({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  void initState() {
    //tz.initializeTimeZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 60,
      color: Color.fromARGB(255, 111, 103, 103),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            Text(
              widget.note.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(widget.note.content),
          ]),
        ],
      ),
    );
  }
}
