import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/user.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../widgets/create_profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropDownText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        elevation: 4,
        title: Row(children: [
          Text(
            'Diary',
            style: TextStyle(fontSize: 39, color: Colors.cyan.shade300),
          ),
          Text(
            'Web',
            style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade200),
          )
        ]),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  items: <String>['Latest', 'Earliest'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ));
                  }).toList(),
                  hint: (_dropDownText == null)
                      ? Text('Select')
                      : Text(_dropDownText!),
                  onChanged: (value) {
                    if (value == 'Latest') {
                      setState(() {
                        _dropDownText = value;
                      });
                    } else if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
                      });
                    }
                  },
                ),
              ),
              //TODO create profile
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final usersListStream = snapshot.data!.docs.map((docs) {
                    return MUser.fromDocument(docs);
                  }).where((muser) {
                    return (muser.uid ==
                        FirebaseAuth.instance.currentUser!.uid);
                  }).toList();
                  MUser curUser = usersListStream[0];

                  return CreateProfile(curUser: curUser);
                },
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                      right: BorderSide(width: 0.4, color: Colors.grey))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfDateRangePicker(
                      onSelectionChanged: (dateRangePickerSelection) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Card(
                      elevation: 4,
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.cyan,
                        ),
                        label: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Write New',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  elevation: 5,
                                  content: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Discard'),
                                                style: TextButton.styleFrom(
                                                    primary: Colors.red),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                child: const Text('Done'),
                                                style: TextButton.styleFrom(
                                                    elevation: 4,
                                                    shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                    backgroundColor:
                                                        Colors.cyanAccent,
                                                    primary: Colors.white),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  color: Colors.white12,
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                          splashRadius: 26,
                                                          onPressed: () {},
                                                          icon: Icon(Icons
                                                              .image_sharp))
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  children: [
                                                    Text('jun 7 2022'),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.8) /
                                                                2,
                                                            child: Container(
                                                                width: 700,
                                                                color: Colors
                                                                    .green,
                                                                child: Text(
                                                                    'image here')),
                                                          ),
                                                          TextFormField()
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ))
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: const Card(
                                elevation: 4,
                                child: ListTile(
                                  title: Text("Hello"),
                                ),
                              ),
                            );
                          },
                        ))
                      ],
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
