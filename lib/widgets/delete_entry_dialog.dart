import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/diary.dart';

AlertDialog DeleteEntryDialog(BuildContext context,
    CollectionReference<Object?> bookCollectionReference, Diary diary) {
  return AlertDialog(
    title: Text(
      'Delete Entry?',
      style: TextStyle(color: Colors.red),
    ),
    content: Text(
        'Are you sure you want to deleted the entry? \n This action cannot be reverser'),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
          )),
      TextButton(
          onPressed: () {
            bookCollectionReference.doc(diary.id).delete().then((value) {
              return Navigator.of(context).pop();
            });
          },
          child: Text(
            'Delete',
          )),
    ],
  );
}
