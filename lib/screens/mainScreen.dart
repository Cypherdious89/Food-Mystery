import 'package:flutter/material.dart';
import '../custom_widgets/shadowButton.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF3EE),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 57.5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              "The Cook Blog",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontSize: 45,
                color: Color(0xffab47bc),
              ),
            ),
            new Container(
              height: 316.50,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/cook_blog.jpg"),
                ),
              ),
            ),
            ShadowButton(
              icon: Icon(Icons.arrow_forward_ios,
                  color: Color(0xffab47bc), size: 18.5),
              text: 'Getting Started',
              textSize: 22.5,
              width: 225.0,
              height: 54.0,
              press: () {
                Navigator.pushNamed(context, 'Sign_Up_Screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
