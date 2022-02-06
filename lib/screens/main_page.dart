import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/diary.dart';
import 'package:flutter_diary_web_app/models/user.dart';
import 'package:flutter_diary_web_app/widgets/write_diary_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../widgets/create_profile.dart';
import '../widgets/diary_list_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime selectedDate = DateTime.now();

  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

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
            flex: 4,
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
                      onSelectionChanged: (dateRangePickerSelection) {
                        setState(() {
                          selectedDate = dateRangePickerSelection.value;
                        });
                      },
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
                                return WriteDiaryDialog(
                                    selectedDate: selectedDate,
                                    titleTextController: _titleTextController,
                                    descriptionTextController:
                                        _descriptionTextController);
                              });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(flex: 10, child: DiaryListView())
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
