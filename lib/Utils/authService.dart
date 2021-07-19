import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHandler{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResult result;
  FirebaseUser user;
  Future<bool> createEmailUser(String email , String password) async {
    result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    user = result.user;
    if (user != null){
      return true;
    }
    else{
      return false;
    }
  }
  Future<bool> signInEmailUser(String email , String password) async {
    result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    user = result.user;
    if (user != null){
      return true;
    }
    else{
      return false;
    }
  }
  Future<bool> signInGoogle() async {
    try{
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null){
        return false;
      }
      else{
        result = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(idToken: (await account.authentication).idToken, accessToken: (await account.authentication).accessToken));
        if(result.user == null){
          return false;
        }
        else{
          user = result.user;
          return true;
        }
      }
    }
    catch(error){
      print(error);
      return false;
    }
  }
  signOutUser() async {
    await _auth.signOut();
  }
}