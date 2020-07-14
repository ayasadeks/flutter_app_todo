import 'package:flutter/material.dart';
import 'package:flutter_app/screens/auth_screen.dart';
import 'package:flutter_app/widgets/buttonDesign.dart';

class FirstScreen extends StatelessWidget {
  static const routeName = '/first-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset("assets/images/logo.png"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonDesign(
                  text: "Get Started",
                  bgColor: Colors.white,
                  buttonTxtColor: Colors.lightBlue,
                  onPressed: () {
                    Navigator.of(context).pushNamed(AuthScreen.routeName);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
