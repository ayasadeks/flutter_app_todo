import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/authForm.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: deviceSize.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Hello!',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 260,
                      ),
                    )
                  ],
                )
              ],
            ),
            AuthForm(),
          ],
        ),
      ),
    );
  }
}
