import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/favouriteRecipes.dart';
import './screens/newRecipeScreen.dart';
import './screens/registrationScreen.dart';
import './screens/userRecipes.dart';

import './screens/mainScreen.dart';
import './screens/signInScreen.dart';
import './screens/signUpScreen.dart';
import './screens/itemsScreen.dart';
import './screens/userProfile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthCheck(),
      routes: {
        'Main_Screen': (context) => MainScreen(),
        'Sign_Up_Screen': (context) => SignUpScreen(),
        'Sign_In_Screen': (context) => SignInScreen(),
        'Item_Screen': (context) => ItemScreen(),
        'Regis_Screen': (context) => RegistrationScreen(),
        'New_Recipe': (context) => NewRecipe(),
        'user_Details': (context) => UserProfile(),
        'user_favs': (context) => FavouriteRecipes(),
        'User_Recipes': (context) => UserRecipes(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.data == null) {
          return MainScreen();
        } else {
          return ItemScreen();
        }
      },
    );
  }
}
