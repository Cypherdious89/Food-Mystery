import 'package:flutter/material.dart';

class ShadowButton extends StatelessWidget {
  ShadowButton(
      {this.icon,
      @required this.text,
      @required this.textSize,
      @required this.width,
      @required this.height,
      @required this.press});
  final dynamic icon;
  final String text;
  final double textSize;
  final double width, height;
  final Function press;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.0),
          color: const Color(0xfffcf3ee),
          border: Border.all(width: 1.0, color: const Color(0xfffcf3ee)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xe6bb6bc9),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontSize: textSize,
                color: Color(0xffab47bc),
              ),
            ),
            SizedBox(width: 5),
            icon,
          ],
        ),
      ),
    );
  }
}
