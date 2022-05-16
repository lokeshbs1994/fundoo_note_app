import 'package:cloud_firestore/cloud_firestore.dart';

class NoteFields {
  static final List<String> values = [id, title, content, createdAt, isArchive];
  static final String id = '_id';
  static final String title = 'title';
  static final String content = 'content';
  static final String createdAt = 'createdAt';
  static final String isArchive = 'isArchive';
}

class Note {
  late String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isArchive;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isArchive = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt,
        'isArchive': isArchive
      };

  static Note fromJson(QueryDocumentSnapshot<Object?> doc) {
    return Note(
      id: doc["id"],
      title: doc["title"],
      content: doc["content"],
      createdAt: DateTime.now(),
      isArchive: doc["isArchive"],
    );
  }

  Map<String, dynamic> toSqJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.content: content,
        NoteFields.createdAt: createdAt.toIso8601String(),
        NoteFields.isArchive: isArchive ? 1 : 0,
      };

  static Note fromSqJson(Map<String, Object?> json) => Note(
      id: json[NoteFields.id] as String,
      title: json[NoteFields.title] as String,
      content: json[NoteFields.title] as String,
      createdAt: DateTime.parse(json[NoteFields.createdAt] as String),
      isArchive: json[NoteFields.isArchive] == 1);
}
