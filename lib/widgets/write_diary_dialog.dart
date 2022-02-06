import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/diary.dart';
import 'package:flutter_diary_web_app/utils/utils.dart';

class WriteDiaryDialog extends StatefulWidget {
  const WriteDiaryDialog({
    Key? key,
    this.selectedDate,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
  })  : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  final DateTime? selectedDate;

  @override
  State<WriteDiaryDialog> createState() => _WriteDiaryDialogState();
}

class _WriteDiaryDialogState extends State<WriteDiaryDialog> {
  var _buttonText = 'Done';
  CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Discard'),
                    style: TextButton.styleFrom(primary: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(_buttonText),
                    style: TextButton.styleFrom(
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        backgroundColor: Colors.green,
                        primary: Colors.white),
                    onPressed: () {
                      final _fieldsNotEmpty =
                          widget._titleTextController.toString().isNotEmpty &&
                              widget._descriptionTextController.text
                                  .toString()
                                  .isNotEmpty;
                      if (_fieldsNotEmpty) {
                        diaryCollectionReference.add(Diary(
                                title: widget._titleTextController.text,
                                entry: widget._descriptionTextController.text,
                                auther: FirebaseAuth
                                    .instance.currentUser!.email!
                                    .split('@')[0],
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                entryTime:
                                    Timestamp.fromDate(widget.selectedDate!))
                            .toMap());
                      }

                      setState(() {
                        _buttonText = 'Saving...';
                      });
                      Future.delayed(
                        const Duration(milliseconds: 2500),
                      ).then((value) => Navigator.of(context).pop());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white12,
                      child: Column(
                        children: [
                          IconButton(
                              splashRadius: 26,
                              onPressed: () {},
                              icon: Icon(Icons.image_sharp))
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatDate(widget.selectedDate!)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height * 0.8) /
                                        2,
                                child: Container(
                                    width: 700,
                                    color: Colors.green,
                                    child: Text('image here')),
                              ),
                              TextFormField(
                                controller: widget._titleTextController,
                                decoration:
                                    InputDecoration(hintText: 'Give title'),
                              ),
                              TextFormField(
                                maxLines: null,
                                controller: widget._descriptionTextController,
                                decoration: InputDecoration(
                                    hintText: 'Write Your Thoughts'),
                              )
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
  }
}
