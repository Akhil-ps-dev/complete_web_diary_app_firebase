import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/models/user.dart';
import 'package:flutter_diary_web_app/widgets/input_decoration.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
    Key? key,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
    GlobalKey<FormState>? formKey,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        _globalKey = formKey,
        super(key: key);

  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;
  final GlobalKey<FormState>? _globalKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Please enter a valid email and password this is at least 6 charactors '),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _emailTextController,
              decoration: buildInputDecoration('email', 'philip@email.com'),
              validator: (value) {
                return value!.isEmpty ? 'Please enter an email' : null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              obscureText: true,
              controller: _passwordTextController,
              decoration: buildInputDecoration('password', ''),
              validator: (value) {
                return value!.isEmpty ? 'Please enter a password' : null;
              },
            ),
          ),
          SizedBox(height: 20),
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  primary: Colors.white,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textStyle: TextStyle(fontSize: 18)),
              onPressed: () {
                if (_globalKey!.currentState!.validate()) {
                  String email = _emailTextController.text;

                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: _passwordTextController.text)
                      .then((value) {
//* create user
//avatar
//name
//uid
                    MUser user = MUser(
                      displayName: email.split('@')[0],
                      avatarUrl: 'https//google.com',
                      profession: 'something',
                      uid: value.user!.uid,
                    );
                    // Map<String, dynamic> user = {
                    //   'display_name': email.toString().split('@')[0],
                    //   'avatar_url': 'https//google.com',
                    //   'profession': 'Hellow World',
                    //   'uid': value.user!.uid
                    // };

                    FirebaseFirestore.instance
                        .collection('users')
                        .add(user.toMap());
                  });
                }
              },
              child: const Text('Create Account'))
        ],
      ),
    );
  }
}
