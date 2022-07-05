import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/js.dart';

import 'package:flutter_diary_web_app/models/diary.dart';
import 'package:flutter_diary_web_app/screens/main_page.dart';
import 'package:flutter_diary_web_app/utils/utils.dart';
import 'package:flutter_diary_web_app/widgets/delete_entry_dialog.dart';

class DiaryListView extends StatelessWidget {
  DiaryListView({
    Key? key,
    // required   this.diary,
  }) : super(key: key);
// final Diary diary;

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _titleTextController = TextEditingController(text: diary.title);
    // final TextEditingController _descriptionTextController = TextEditingController(text: diary.entry);

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

                                                //!edit dialog
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            elevation: 5,
                                                            content: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('Discard'),
                                                                          style:
                                                                              TextButton.styleFrom(primary: Colors.red),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            TextButton(
                                                                          child:
                                                                              Text('Done'),
                                                                          style: TextButton.styleFrom(
                                                                              elevation: 4,
                                                                              shape: const RoundedRectangleBorder(side: BorderSide(width: 1, color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                              backgroundColor: Colors.green,
                                                                              primary: Colors.white),
                                                                          onPressed:
                                                                              () {},
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          height: MediaQuery.of(context)
                                                                              .size
                                                                              .height,
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: IconButton(onPressed: () {}, splashRadius: 26, icon: Icon(Icons.image_rounded)),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: IconButton(onPressed: () {}, splashRadius: 26, color: Colors.red, icon: Icon(Icons.delete_outline_rounded)),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              50,
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text('${formatDateFromTimestamp(diary.entryTime)}'),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: SizedBox(
                                                                                  width: MediaQuery.of(context).size.width * 0.60,
                                                                                  height: MediaQuery.of(context).size.height * 0.40,
                                                                                  child: Image.network(
                                                                                    (diary.photoUrls == null) ? 'https://picsum.photos/200/300' : diary.photoUrls.toString(),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.5,
                                                                                child: Form(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      //SizedBox(height: (MediaQuery.of(context).size.height * 0.8) / 2, child: _imageWidget),
                                                                                      TextFormField(
                                                                                        validator: (value) {},
                                                                                        //     controller: _titleTextController,
                                                                                        decoration: InputDecoration(hintText: 'Give title'),
                                                                                      ),
                                                                                      TextFormField(
                                                                                        maxLines: null,
                                                                                        //   controller:_descriptionTextController,
                                                                                        decoration: InputDecoration(hintText: 'Write Your Thoughts'),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
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
