import 'package:cloud_firestore/cloud_firestore.dart';

class Student {  
  //final String uid;
  final String id;
  final String username;
  final String photoUrl;
  final String email;
  final String displayName;
  final Timestamp timestamp;

  Student({ this.id, this.username, this.photoUrl, this.email, this.displayName, this.timestamp });
  
  factory Student.fromDocument(DocumentSnapshot doc) {
    return Student(
      id: doc['id'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      displayName: doc['displayName'],
      timestamp: doc['timestamp'],
    );  
  }
}