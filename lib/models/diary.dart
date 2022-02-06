import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String? id;

  final String? userId;
  final String? title;

  final String? auther;

  final Timestamp? entryTime;

  final String? photoUrls;
  final String? entry;

  Diary(
      {this.id,
      this.userId,
      this.title,
      this.auther,
      this.entryTime,
      this.photoUrls,
      this.entry});

  factory Diary.fromDocument(QueryDocumentSnapshot data) {
    return Diary(
        id: data.id,
        userId: data.get('user_id'),
        auther: data.get('author'),
        entryTime: data.get('entry_Time'),
        photoUrls: data.get('photo_list'),
        title: data.get('title'),
        entry: data.get('entry'));
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'author': auther,
      'entry': entry,
      'photo_list': photoUrls,
      'entry_Time': entryTime,
    };
  }
}
