import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/screens/main_page.dart';
import 'package:flutter_diary_web_app/services/service.dart';
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
          const Text(
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
      const    SizedBox(height: 20),
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
                    if (value.user != null) {
                      String uid = value.user!.uid;
                      DiaryService()
                          .createUser(email.split('@')[0], context, uid)
                          .then((value) {
                        DiaryService()
                            .loginUser(email, _passwordTextController.text)
                            .then((value) {
                          return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()));
                        });
                      });
                    }
                  });
                }
              },
              child: const Text('Create Account'))
        ],
      ),
    );
  }
}
