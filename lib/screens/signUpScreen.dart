import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../custom_widgets/shadowButton.dart';
import '../Utils/authService.dart';
import './emailScreen.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  AuthHandler authenticationService = AuthHandler();
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Google Sign In failed!",
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontSize: 20,
                color: Color(0xffab47bc),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Your Google Sign In failed!'),
                  Text('Please try again with this or different account.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Dismiss',
                  style: TextStyle(
                    color: Color(0xffab47bc),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF3EE),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56.5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Start the journey of your own food blogs with\nCook Blog  ",
              style: TextStyle(
                fontFamily: "Segoe UI Historic",
                fontSize: 32,
                color: Color(0xffab47bc),
              ),
            ),
            new Container(
              height: 204.00,
              width: 272.00,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/omellete.png"),
                ),
              ),
            ),
            ShadowButton(
              icon: FaIcon(FontAwesomeIcons.google,
                  color: Color(0xffab47bc), size: 22.5),
              text: 'Sign Up using ',
              textSize: 22.5,
              width: 220,
              height: 48,
              press: () async {
                bool result = await authenticationService.signInGoogle();
                if (!result) {
                  createAlertDialog(context);
                } else {
                  Navigator.pushNamed(context, 'Regis_Screen');
                }
              },
            ),
            ShadowButton(
              icon: Icon(Icons.mail, color: Color(0xffab47bc), size: 22.5),
              text: 'Sign Up using ',
              textSize: 22.5,
              width: 220,
              height: 48,
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmailScreen(option: "Sign Up")));
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'Sign_In_Screen');
              },
              child: Text(
                "Already have an account? Sign In",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontSize: 16.5,
                  color: Color(0xffab47bc),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
