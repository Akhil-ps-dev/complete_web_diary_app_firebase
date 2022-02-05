import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/widgets/create_account_form.dart';
import 'package:flutter_diary_web_app/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();

  final GlobalKey<FormState>? _globalKey = GlobalKey<FormState>();

  bool isCreatedAccountClicked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Color(0XFFB9C2D1),
              ),
            ),
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: isCreatedAccountClicked
                      ? CreateAccountForm(
                          formKey: _globalKey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController)
                      : LoginForm(
                          formKey: _globalKey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController),
                ),
                TextButton.icon(
                  icon: Icon(Icons.person_sharp),
                  label: Text(isCreatedAccountClicked
                      ? 'Already have an account ?'
                      : 'Create account'),
                  style:
                      TextButton.styleFrom(textStyle: TextStyle(fontSize: 15)),
                  onPressed: () {
                    setState(() {
                      if (!isCreatedAccountClicked) {
                        isCreatedAccountClicked = true;
                      } else {
                        isCreatedAccountClicked = false;
                      }
                    });
                  },
                )
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0XFFB9C2D1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
