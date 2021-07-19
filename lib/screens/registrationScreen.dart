import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../custom_widgets/shadowButton.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _nameControl = TextEditingController(text: "");
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  void getCurrentUser() async {
    user = await _auth.currentUser();
  }

  List<bool> checkValue = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> availableCuisines = [
    'Continental',
    'Chinese',
    'Punjabi',
    'South Indian',
    'Thai',
    'Goan',
    'Mughal',
    'Gujarati',
    'Rajasthani',
    'Maharashtarian',
    'Bengali',
    'North Indian'
  ];
  List<String> favouriteCuisines = [];
  String _gender = "Male";
  Firestore _firestore = Firestore.instance;
  List<Widget> checkBoxBuilder() {
    List<Widget> checkList = [];
    for (int i = 0; i < 12; ++i) {
      checkList.add(CheckboxListTile(
        value: checkValue[i],
        onChanged: (bool value) {
          setState(() {
            checkValue[i] = value;
            if (checkValue[i] == true) {
              favouriteCuisines.add(availableCuisines[i]);
            } else if (checkValue[i] == false) {
              favouriteCuisines.remove(availableCuisines[i]);
            }
          });
        },
        title: Text(availableCuisines[i],
            style: TextStyle(fontFamily: 'Segeo UI', fontSize: 17.5)),
        activeColor: Color(0xffab47bc),
      ));
    }
    checkList.add(ShadowButton(
        icon: Icon(Icons.arrow_forward, color: Color(0xffab47bc), size: 17.5),
        text: "Let's Go!",
        textSize: 22.5,
        width: 210,
        height: 48,
        press: () {
          _firestore.collection('users').document(user.email).setData({
            'Name': _nameControl.text,
            'Gender': _gender,
            'Favourite Cuisines': favouriteCuisines,
          });
          _nameControl.dispose();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('Item_Screen', (route) => false);
        }));
    return checkList;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xFFFCF3EE),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.5, vertical: 5),
            child: new ListView(children: <Widget>[
              SizedBox(height: 25),
              new Text(
                "One more step...",
                style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontSize: 35.5,
                  color: Color(0xffab47bc),
                ),
              ),
              SizedBox(height: 25),
              new Text(
                "Let us know more about you!",
                style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontSize: 22.5,
                  color: Color(0xffab47bc),
                ),
              ),
              SizedBox(height: 35),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new TextField(
                    controller: _nameControl,
                    decoration: InputDecoration(
                      hintText: "What should we call you?",
                      icon: Icon(Icons.spellcheck,
                          color: Color(0xFFab47bc), size: 22.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(17.5)),
                        borderSide:
                            BorderSide(color: Color(0xFFab47bc), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFab47bc), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(17.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFab47bc), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(17.5)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  new Text(
                    'Gender',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 20.5,
                      color: Color(0xffab47bc),
                    ),
                  ),
                  SizedBox(height: 10),
                  new ListTile(
                    leading: Radio(
                      value: "Male",
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      activeColor: Color(0xFFab47bc),
                    ),
                    title: Text('Male',
                        style:
                            TextStyle(fontFamily: 'Segeo UI', fontSize: 17.5)),
                  ),
                  new ListTile(
                    leading: Radio(
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      activeColor: Color(0xFFab47bc),
                    ),
                    title: Text('Female',
                        style:
                            TextStyle(fontFamily: 'Segeo UI', fontSize: 17.5)),
                  ),
                  new ListTile(
                    leading: Radio(
                      value: "Prefer not to say",
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      activeColor: Color(0xFFab47bc),
                    ),
                    title: Text('Prefer not to say',
                        style:
                            TextStyle(fontFamily: 'Segeo UI', fontSize: 17.5)),
                  ),
                  SizedBox(height: 20),
                  new Text(
                    'Favourite Cuisines',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 20.5,
                      color: Color(0xffab47bc),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: checkBoxBuilder(),
              )
            ])));
  }
}
