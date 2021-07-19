import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../custom_widgets/recipeCard.dart';
import './recipeDetails.dart';

class UserRecipes extends StatefulWidget {
  @override
  _UserRecipesState createState() => _UserRecipesState();
}

class _UserRecipesState extends State<UserRecipes> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email;
  List<Widget> recipeCards = [];
  void getCurrentUser() async {
    user = await _auth.currentUser();
    setState(() {
      email = user.email;
    });
  }

  List<Widget> recipeKards = [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Use Refresh Icon to see your recipes!!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "Segoe UI",
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
        Icon(Icons.refresh, color: Color(0xFFab47bc)),
      ],
    )
  ];
  void getDocumentSnapshots(DocumentReference y) async {
    DocumentSnapshot recipe = await y.get();
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

  @override
  void initState() {
    getCurrentUser();
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
          icon: Icon(Icons.arrow_back, size: 35, color: Color(0xFFab47bc)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh, color: Color(0xFFab47bc), size: 35),
              onPressed: () {
                setState(() {
                  recipeKards = recipeCards;
                });
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, top: 5, right: 7.5, bottom: 5),
        child: Container(
          child: StreamBuilder(
            stream: _firestore
                .collection("users")
                .document("$email")
                .collection("My Recipes")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot x = snapshot.data;
                for (var recipes in x.documents) {
                  getDocumentSnapshots(recipes.data["Reference"]);
                }
                return ListView(
                  children: recipeKards,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
