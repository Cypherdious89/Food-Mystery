import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String email;
  Firestore _firestore = Firestore.instance;
  String userName;
  String gender;
  List<dynamic> favouriteCuisines = [];
  List<Widget> cuisineCards = [];
  void getCurrentUser() async {
    user = await _auth.currentUser();
    email = user.email;
  }

  void getUserDetails() async {
    final userDetails = await _firestore.collection("users").getDocuments();
    for (var currentUser in userDetails.documents) {
      if (email == currentUser.documentID) {
        setState(() {
          userName = currentUser.data["Name"];
          gender = currentUser.data["Gender"];
          favouriteCuisines = currentUser.data["Favourite Cuisines"];
        });
      }
    }
  }

  List<Widget> makeCuisineCards() {
    for (var cuisineName in favouriteCuisines) {
      var newCard = Container(
          height: 50,
          width: 200,
          child: Card(
            elevation: 4,
            child: Center(
              child: Text(
                "$cuisineName",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Segoe UI",
                  color: Color(0xFFab47bc),
                ),
              ),
            ),
          ));
      cuisineCards.add(newCard);
      cuisineCards.add(SizedBox(height: 10));
    }
    return cuisineCards;
  }

  @override
  void initState() {
    getCurrentUser();
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF3EE),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF3EE),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 30, color: Color(0xFFab47bc)),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: userName == null
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFab47bc)),
              ))
            : ListView(
                children: <Widget>[
                  CircleAvatar(
                      radius: 55,
                      child: Center(
                          child: Text(
                        "${userName[0]}",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Segoe UI",
                        ),
                      ))),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "$userName",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Segoe UI",
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: FaIcon(
                      gender == "Male"
                          ? FontAwesomeIcons.mars
                          : (gender == "Female"
                              ? FontAwesomeIcons.venus
                              : FontAwesomeIcons.genderless),
                      size: 65,
                      color: Color(0xFFab47bc),
                    ),
                  ),
                  Center(
                    child: Text(
                      '$gender',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Segoe UI",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Favourite Cuisines',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Segoe UI",
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: makeCuisineCards(),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
      ),
    );
  }
}
