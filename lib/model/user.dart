import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'photoUrl': photoUrl,
      };

  static User fromJson(DocumentSnapshot<Object?> doc) {
    return User(
        email: doc["email"],
        uid: doc["uid"],
        photoUrl: doc["photoUrl"],
        username: doc['username'],
        bio: doc['bio']);
  }
}
