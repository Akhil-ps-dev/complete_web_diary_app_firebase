import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/diary.dart';
import 'package:flutter_diary_web_app/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'dart:html' as html;

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
  html.File? _cloudFile;
  var _fileBytes;
  Image? _imageWidget;

  var _buttonText = 'Done';
  String? currId;

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
                      firebase_storage.FirebaseStorage fs =
                          firebase_storage.FirebaseStorage.instance;
                      final dateTime = DateTime.now();

                      final path = '$dateTime';

                      final _fieldsNotEmpty =
                          widget._titleTextController.toString().isNotEmpty &&
                              widget._descriptionTextController.text
                                  .toString()
                                  .isNotEmpty;

                      if (_fieldsNotEmpty) {
                        diaryCollectionReference
                            .add(Diary(
                                    title: widget._titleTextController.text,
                                    entry:
                                        widget._descriptionTextController.text,
                                    auther: FirebaseAuth
                                        .instance.currentUser!.email!
                                        .split('@')[0],
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    entryTime: Timestamp.fromDate(
                                        widget.selectedDate!))
                                .toMap())
                            .then((value) {
                          setState(() {
                            currId = value.id;
                          });
                          return null;
                        });
                      }

                      if (_fileBytes != null) {
                        firebase_storage.SettableMetadata? metadata =
                            firebase_storage.SettableMetadata(
                                contentType: 'image/jpeg',
                                customMetadata: {'picked-file-path': path});

                        Future.delayed(.................const Duration(milliseconds: 1500))
                            .then((value) {
                          fs
                              .ref()
                              .child(
                                  'images/$path${FirebaseAuth.instance.currentUser!.uid}')
                              .putData(_fileBytes, metadata)
                              .then((value) {
                            return value.ref.getDownloadURL().then((value) {
                              diaryCollectionReference
                                  .doc(currId)
                                  .update({'photo_list': value.toString()});
                            });
                          });
                          return null;
                        });
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
                            icon: Icon(Icons.image_sharp),
                            onPressed: () async {
                              await getMultipleImageInfos();
                            },
                          )
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
                                  height: (MediaQuery.of(context).size.height *
                                          0.8) /
                                      2,
                                  child: _imageWidget),
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

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    //String? mimeType = mime(Path.basename(mediaData.fileName!));
    // html.File mediaFile =
    //     new html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    setState(() {
      // _cloudFile = mediaFile;
      _fileBytes = mediaData.data;
      _imageWidget = Image.memory(mediaData.data!);
    });
  }
}
