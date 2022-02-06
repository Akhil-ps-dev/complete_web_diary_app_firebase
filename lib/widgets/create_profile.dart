import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/screens/Login/login_page.dart';
import 'package:flutter_diary_web_app/widgets/update_profile.dart';

import '../models/user.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({
    Key? key,
    required this.curUser,
  }) : super(key: key);

  final MUser curUser;

  @override
  Widget build(BuildContext context) {
    final _avatarUrlTextController =
        TextEditingController(text: curUser.avatarUrl);
    final _displayNameTextController =
        TextEditingController(text: curUser.displayName);

    return Row(
      children: [
        Column(
          children: [
            Expanded(
                child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(curUser.avatarUrl!),
                  backgroundColor: Colors.transparent,
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return UpdateUserProfileDialog(
                          curUser: curUser,
                          avatarUrlTextController: _avatarUrlTextController,
                          displayNameTextController:
                              _displayNameTextController);
                    });
              },
            )),
            Text(
              curUser.displayName!,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                return Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              });
            },
            icon: const Icon(
              Icons.logout,
              size: 19,
              color: Colors.red,
            ))
      ],
    );
  }
}
