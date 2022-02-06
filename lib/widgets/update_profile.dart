import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/user.dart';

import '../services/service.dart';

class UpdateUserProfileDialog extends StatelessWidget {
  const UpdateUserProfileDialog({
    Key? key,
    required this.curUser,
    required TextEditingController avatarUrlTextController,
    required TextEditingController displayNameTextController,
  })  : _avatarUrlTextController = avatarUrlTextController,
        _displayNameTextController = displayNameTextController,
        super(key: key);

  final MUser curUser;
  final TextEditingController _avatarUrlTextController;
  final TextEditingController _displayNameTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ))
              ],
            ),
            Text(
              'Editing ${curUser.displayName}',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    controller: _avatarUrlTextController,
                  ),
                  TextFormField(
                    controller: _displayNameTextController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        elevation: 4,
                        primary: Colors.white,
                        backgroundColor: Colors.cyan,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      child: const Text('Update'),
                      onPressed: () {
                        DiaryService().update(
                            curUser,
                            _displayNameTextController.text,
                            _avatarUrlTextController.text,
                            context);

                        Future.delayed(const Duration(milliseconds: 200))
                            .then((value) {
                          return Navigator.of(context).pop();
                        });
                      },
                    ),
                  )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
