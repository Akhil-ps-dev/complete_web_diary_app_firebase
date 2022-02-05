import 'package:flutter/material.dart';
import 'package:flutter_diary_web_app/screens/Login/login_page.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CircleAvatar(
      // backgroundImage: NetworkImage(
      //     'https://images-na.ssl-images-amazon.com/images/I/81ffi2sgT-L.jpg'),
      backgroundColor: Color(0xFFF5F6F8),

      child: Column(
        children: [
          Spacer(),
          Text(
            'Diary Web',
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '"Love the life you live. ..."',
            style: TextStyle(
                fontSize: 29,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            width: 220,
            height: 40,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 15)),
              icon: Icon(Icons.double_arrow_sharp),
              label: Text('Sign in to Get Started'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ),
          Spacer(),
        ],
      ),
    ));
  }
}
