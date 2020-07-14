import 'package:flutter/material.dart';

class ButtonDesign extends StatelessWidget {
  final String text;
  final Color buttonTxtColor;
  final Color bgColor;
  final VoidCallback onPressed;

  const ButtonDesign({Key key, this.text, this.buttonTxtColor, this.bgColor, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      height: 60,
      width: double.infinity,
      child: RaisedButton(
        onPressed: onPressed,
        child: Text(text,
          style: TextStyle(color:buttonTxtColor, fontSize: 18),),
        color: bgColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)),

      ),
    );
  }
}
