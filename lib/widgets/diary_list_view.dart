import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/diary.dart';
import 'package:flutter_diary_web_app/utils/utils.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var filteredList = snapshot.data!.docs.map((diary) {
            return Diary.fromDocument(diary);
          }).where((item) {
            return (item.userId == FirebaseAuth.instance.currentUser!.uid);
          }).toList();

          return Column(
            children: [
              Expanded(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    Diary diary = filteredList[index];
                    return Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${formatDate(diary.entryTime!.toDate())} ',
                                    style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
                                      label: const Text(''))
                                ],
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date...',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color: Colors.grey,
                                      ),
                                      label: Text(''),
                                    ),
                                  ],
                                ),
                                Image.network('https://picsum.photos/200/300'),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                diary.title!,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                diary.entry!,
                                              ),
                                            )
                                          ]),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ))
            ],
          );
        });
  }
}
