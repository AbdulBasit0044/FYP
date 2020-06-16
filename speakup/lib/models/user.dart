import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String photoUrl;
  final String email;
  final String displayName;
  final Timestamp timestamp;

  User({ this.uid, this.username, this.photoUrl, this.email, this.displayName, this.timestamp });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc['uid'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      displayName: doc['displayName'],
      timestamp: doc['timestamp'],
    );  
  }
}