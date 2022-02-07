import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/diary.dart';
import 'package:flutter_diary_web_app/screens/main_page.dart';
import 'package:flutter_diary_web_app/utils/utils.dart';
import 'package:flutter_diary_web_app/widgets/delete_entry_dialog.dart';
import 'package:universal_html/js.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    return StreamBuilder<QuerySnapshot>(
        stream: bookCollectionReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
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
                      //selectedDate:
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
                                    '${formatDateFromTimestamp(diary.entryTime)} ',
                                    style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton.icon(
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DeleteEntryDialog(
                                                  context,
                                                  bookCollectionReference,
                                                  diary);
                                            });
                                      },
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
                                      '🕒 ${formatDateFromTimestampHour(diary.entryTime)} ',
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
                                Image.network((diary.photoUrls == null)
                                    ? 'https://picsum.photos/200/300'
                                    : diary.photoUrls.toString()),
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
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${formatDateFromTimestamp(diary.entryTime)}',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Container();
                                                        });
                                                  },
                                                  icon: Icon(Icons.edit),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return DeleteEntryDialog(
                                                              context,
                                                              bookCollectionReference,
                                                              diary);
                                                        });
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      content: ListTile(
                                        subtitle: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${formatDateFromTimestampHour(diary.entryTime)}',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.60,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.50,
                                              child: Image.network((diary
                                                          .photoUrls ==
                                                      null)
                                                  ? 'https://picsum.photos/200/300'
                                                  : diary.photoUrls.toString()),
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '${diary.title}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '${diary.entry}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'))
                                      ],
                                    );
                                  });
                            },
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
