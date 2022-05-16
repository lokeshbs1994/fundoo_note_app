import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagram_flutter/main.dart';
import 'package:instagram_flutter/resources/database_manager.dart';
import 'package:instagram_flutter/resources/note_service.dart';
import 'package:instagram_flutter/resources/sqlflite_manager.dart';

import 'package:intl/intl.dart';
import '../model/note.dart';

class EditNote extends StatefulWidget {
  final Note note;

  const EditNote({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController titleEditingController;
  late TextEditingController contentEditngController;
  DateTime? remainderTime;

  @override
  void initState() {
    titleEditingController = TextEditingController(text: widget.note.title);
    contentEditngController = TextEditingController(text: widget.note.content);
    //remainderTime = widget.note.dateTime;
    super.initState();
  }

  String getText() {
    if (remainderTime == null) {
      return '';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(remainderTime!);
    }
  }

  void updateNote() async {
    final id = widget.note.id;
    final title = titleEditingController.text;
    final content = contentEditngController.text;

    await DatabaseManager.getInstance().updateNotes(
      id: id,
      title: title,
      content: content,
    );
    List<Map<String, dynamic>> notess =
        await SqlFliteManager.getInstance().readAllNotes();

    print(notess);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        FlatButton(
          minWidth: 10,
          onPressed: updateNote,
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.save_as),
            ],
          ),
        ),
        FlatButton(
          minWidth: 10,
          onPressed: () async {
            await DatabaseManager.getInstance().delete(widget.note.id);
            List<Map<String, dynamic>> notess =
                await SqlFliteManager.getInstance().readAllNotes();

            print(notess);
            Navigator.pop(context);
          },
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.delete),
            ],
          ),
        ),
        FlatButton(
          minWidth: 10,
          onPressed: () async {
            await pickDateTime(context);
            displayNotification(widget.note);
          },
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.alarm_add),
            ],
          ),
        ),
        FlatButton(
          minWidth: 10,
          onPressed: () async {
            await DatabaseManager.getInstance().archNote(widget.note);
            Navigator.pop(context);
          },
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Icon(widget.note.isArchive
                  ? Icons.archive
                  : Icons.archive_outlined),
            ],
          ),
        ),
      ]),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: TextField(
              controller: titleEditingController,
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
                controller: contentEditngController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(hintText: 'Content'),
              ),
            ),
          ),
          Container(
            child: Text(
              getText(),
              style: TextStyle(backgroundColor: Colors.grey),
            ),
          )
        ]),
      ),
    );
  }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      remainderTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: remainderTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: remainderTime != null
          ? TimeOfDay(hour: remainderTime!.hour, minute: remainderTime!.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }

  void displayNotification(Note note) async {
    var scheduledNotificationDateTime = remainderTime ??
        DateTime.now().add(
            Duration(seconds: 1)); //DateTime.now().add(Duration(seconds: 1))
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      //'Channel for Alarm notification',
      icon: 'my_logo',
      sound: RawResourceAndroidNotificationSound(
          'android_app_src_main_res_raw_a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('my_logo'),
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationsPlugin.schedule(0, note.title, note.content,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }
}
