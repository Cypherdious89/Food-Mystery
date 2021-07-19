import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDetails extends StatefulWidget {
  RecipeDetails(
      {@required this.recipeName,
      @required this.duration,
      @required this.instructions,
      @required this.ingredients,
      @required this.recipeCuisine,
      @required this.cookName,
      @required this.dishImage,
      @required this.rating,
      @required this.likes,
      @required this.postTime});
  final String recipeName;
  final String recipeCuisine;
  final dynamic ingredients;
  final dynamic duration;
  final String instructions;
  final String cookName;
  final String dishImage;
  final double rating;
  final int likes;
  final dynamic postTime;
  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  int newLikes = 0;
  double userRating = 0;
  bool userLikeStatus = false;
  List<String> ingredientNames = [];
  List<String> ingredientQuantities = [];
  IconData likeIcon = Icons.favorite_border;
  void getEmail() async {
    FirebaseUser user = await _auth.currentUser();
    email = user.email;
    checkIfLike(email);
  }

  void getIngredientList() {
    for (var ingredient in widget.ingredients.keys) {
      ingredientNames.add(ingredient);
      ingredientQuantities.add(widget.ingredients[ingredient]);
    }
  }

  List<TableRow> getIngredientTable() {
    List<TableRow> rows = [];
    for (var i = 0; i < ingredientNames.length; ++i) {
      rows.add(TableRow(
        children: [
          Text(
            "${ingredientNames[i]}",
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w500,
              fontFamily: "Segoe UI",
            ),
          ),
          Text(
            "${ingredientQuantities[i]}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w500,
              fontFamily: "Segoe UI",
            ),
          ),
        ],
      ));
    }
    return rows;
  }

  void updateFirestore() {
    if (userRating != 0) {
      _firestore.collection("recipes").document(widget.recipeName).updateData({
        "Avg Rating": (widget.rating + userRating) / 2,
        "Likes": newLikes,
      });
      _firestore
          .collection("cuisines")
          .document(widget.recipeCuisine)
          .collection("recipes")
          .document(widget.recipeName)
          .updateData({
        "Avg Rating": (widget.rating + userRating) / 2,
        "Likes": newLikes,
      });
    } else {
      _firestore.collection("recipes").document(widget.recipeName).updateData({
        "Avg Rating": widget.rating,
        "Likes": newLikes,
      });
      _firestore
          .collection("cuisines")
          .document(widget.recipeCuisine)
          .collection("recipes")
          .document(widget.recipeName)
          .updateData({
        "Avg Rating": widget.rating,
        "Likes": newLikes,
      });
    }
  }

  void addUserLiked() {
    if (userRating != 0) {
      _firestore
          .collection("users")
          .document(email)
          .collection("Liked Recipes")
          .document(widget.recipeName)
          .setData({
        "Name": widget.recipeName,
        "Cook Name": widget.cookName,
        "Cooking Duration": widget.duration,
        "Cuisine": widget.recipeCuisine,
        "Ingredients": widget.ingredients,
        "Instructions": widget.instructions,
        "imageURL": widget.dishImage,
        "Likes": newLikes,
        "User Rating": userRating,
        "Avg Rating": (widget.rating + userRating) / 2,
        "Post Time": widget.postTime,
        "Liked Time": DateTime.now(),
      });
    } else {
      _firestore
          .collection("users")
          .document(email)
          .collection("Liked Recipes")
          .document(widget.recipeName)
          .setData({
        "Name": widget.recipeName,
        "Cook Name": widget.cookName,
        "Cooking Duration": widget.duration,
        "Cuisine": widget.recipeCuisine,
        "Ingredients": widget.ingredients,
        "Instructions": widget.instructions,
        "imageURL": widget.dishImage,
        "Likes": newLikes,
        "User Rating": 0,
        "Avg Rating": widget.rating,
        "Post Time": widget.postTime,
        "Liked Time": DateTime.now(),
      });
    }
  }

  void deleteUserLikes() {
    _firestore
        .collection("users")
        .document(email)
        .collection("Liked Recipes")
        .document(widget.recipeName)
        .delete();
  }

  // ignore: non_constant_identifier_names
  void checkIfLike(String Email) async {
    final likedRecipes = await _firestore
        .collection("users")
        .document(Email)
        .collection("Liked Recipes")
        .getDocuments();
    for (var recipes in likedRecipes.documents) {
      if (widget.recipeName == recipes.documentID) {
        setState(() {
          userLikeStatus = true;
          likeIcon = Icons.favorite;
        });
        return;
      }
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    getIngredientList();
    getEmail();
    newLikes = widget.likes;
  }

  @override
  // ignore: must_call_super
  void deactivate() {
    updateFirestore();
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
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ListView(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Color(0xFFab47bc),
                minRadius: 75,
                maxRadius: 220,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.dishImage),
                  minRadius: 45,
                  maxRadius: 190,
                ),
              ),
              SizedBox(height: 5),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 75,
                    child: Text(
                      "${widget.recipeName}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Segoe UI",
                      ),
                    ),
                  ),
                  SizedBox(height: 22.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Recipe By: ",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Segoe UI",
                        ),
                      ),
                      Text(
                        "${widget.cookName}",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Segoe UI",
                          color: Color(0xFFab47bc),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Swipe down to see more ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Segoe UI",
                          color: Color(0xFFab47bc),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down,
                          size: 20, color: Color(0xFFab47bc)),
                    ],
                  ),
                  SizedBox(height: 57.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Cooking Duration: ",
                        style: TextStyle(
                          fontSize: 22.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Segoe UI",
                        ),
                      ),
                      Text(
                        "${widget.duration["hours"]}:${widget.duration["minutes"]} hours ",
                        style: TextStyle(
                          fontSize: 22.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Segoe UI",
                          color: Color(0xFFab47bc),
                        ),
                      ),
                      Icon(Icons.timer, size: 22.5, color: Color(0xFFab47bc)),
                    ],
                  ),
                  SizedBox(height: 22.5),
                  Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 27.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Segoe UI",
                    ),
                  ),
                  SizedBox(height: 22.5),
                  Table(
                    children: getIngredientTable(),
                  ),
                  SizedBox(height: 22.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Cooking Instructions ",
                        style: TextStyle(
                          fontSize: 27.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Segoe UI",
                        ),
                      ),
                      Icon(Icons.whatshot, size: 30, color: Color(0xFFab47bc))
                    ],
                  ),
                  SizedBox(height: 22.5),
                  Text(
                    "${widget.instructions}",
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Segoe UI",
                    ),
                  ),
                  SizedBox(height: 22.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Your Rating ",
                        style: TextStyle(
                          fontSize: 27.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Segoe UI",
                        ),
                      ),
                      Icon(Icons.star_half, size: 30, color: Color(0xFFab47bc))
                    ],
                  ),
                  SizedBox(height: 22.5),
                  SmoothStarRating(
                      allowHalfRating: true,
                      onRated: (v) {
                        setState(() {
                          userRating = v;
                        });
                      },
                      starCount: 5,
                      rating: 0,
                      size: 40.0,
                      isReadOnly: false,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      color: Color(0xFFab47bc),
                      borderColor: Color(0xFFab47bc),
                      spacing: 0.0),
                  SizedBox(height: 22.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Like It",
                        style: TextStyle(
                          fontSize: 27.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Segoe UI",
                        ),
                      ),
                      Icon(Icons.favorite, size: 30, color: Color(0xffFFBF00))
                    ],
                  ),
                  SizedBox(height: 22.5),
                  IconButton(
                      icon: Icon(likeIcon, size: 30, color: Color(0xffFFBF00)),
                      onPressed: () {
                        if (userLikeStatus == false) {
                          setState(() {
                            userLikeStatus = true;
                            newLikes++;
                            likeIcon = Icons.favorite;
                          });
                          addUserLiked();
                        } else if (userLikeStatus == true) {
                          setState(() {
                            userLikeStatus = false;
                            newLikes--;
                            likeIcon = Icons.favorite_border;
                          });
                          deleteUserLikes();
                        }
                      })
                ],
              )
            ],
          ),
        ));
  }
}
