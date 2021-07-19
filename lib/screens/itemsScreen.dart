import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../custom_widgets/recipeCard.dart';
import './recipeDetails.dart';
import './signUpScreen.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Widget> recipeCards = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFCF3EE),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF3EE),
        elevation: 2.5,
        leading: IconButton(
          icon: Icon(Icons.sort, color: Color(0xFFab47bc), size: 35),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("What's Hot",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFab47bc), fontSize: 25)),
            SizedBox(width: 2.5),
            Icon(Icons.whatshot, color: Color(0xFFab47bc), size: 35)
          ],
        )),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, color: Color(0xFFab47bc), size: 35),
              onPressed: null)
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/drawer_wallpaper.jpg"),
                ),
              ),
              child: Text(
                'The Cook Blog',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: "Segoe UI",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu,
                  color: Color(0xffFFBF00), size: 25),
              title: Text(
                'Your recipes',
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Segoe UI",
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'User_Recipes');
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Color(0xffff1418), size: 25),
              title: Text(
                'Your favourites',
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Segoe UI",
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'user_favs');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle,
                  color: Color(0xFF008DF2), size: 25),
              title: Text(
                'Account',
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Segoe UI",
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'user_Details');
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.exit_to_app, color: Color(0xFF00a819), size: 25),
              title: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Segoe UI",
                ),
              ),
              onTap: () {
                _auth.signOut();
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'New_Recipe');
          },
          child: Icon(Icons.playlist_add),
          tooltip: 'Give us a new recipe!'),
      body: Padding(
        padding: EdgeInsets.only(left: 15, top: 5, right: 7.5, bottom: 5),
        child: Container(
            child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection("recipes")
              .orderBy("Post Time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final recipes = snapshot.data.documents;
              List<Widget> recipeCards = [];
              for (var recipe in recipes) {
                final recipeName = recipe.documentID;
                final cookName = recipe.data["Cook Name"];
                final cuisineName = recipe.data["Cuisine"];
                final ingredients = recipe.data["Ingredients"];
                final time = recipe.data["Cooking Duration"];
                final instructions = recipe.data["Instructions"];
                final dishImage = recipe.data["imageURL"];
                final rating = recipe.data["Avg Rating"];
                final ratingData = rating.toDouble();
                final likes = recipe.data["Likes"];
                final postTime = recipe.data["Post Time"];
                final card = RecipeCard(
                    recipe: recipeName,
                    cookName: cookName,
                    dishImage: dishImage,
                    openFunc: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipeDetails(
                                    recipeName: recipeName,
                                    ingredients: ingredients,
                                    duration: time,
                                    instructions: instructions,
                                    recipeCuisine: cuisineName,
                                    cookName: cookName,
                                    dishImage: dishImage,
                                    rating: ratingData,
                                    likes: likes,
                                    postTime: postTime,
                                  )));
                    },
                    cuisineTag: cuisineName,
                    rating: ratingData,
                    likes: likes);
                recipeCards.add(card);
                recipeCards.add(SizedBox(height: 15));
              }
              return ListView(
                children: recipeCards,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFab47bc)),
                ),
              );
            }
          },
        )),
      ),
    );
  }
}
