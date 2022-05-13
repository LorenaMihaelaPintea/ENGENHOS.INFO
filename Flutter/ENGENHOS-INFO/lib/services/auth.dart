import 'package:firebase_auth/firebase_auth.dart';
import 'package:engenhos_info/models/myuser.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a User object based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid, email: user.email!, name: user.displayName, phoneNumber: user.phoneNumber) : null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }

  // sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      // print(error.toString());
      return null;
    }
  }

  // sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);

    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    }
  }
  // sign in with Facebook
  Future signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    } catch (e) {
      print(e.toString());
    }
  }
  // sign up with email
  Future registrationWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updatePassword(String password) async {
    try {
      await _auth.currentUser?.updatePassword(password);
    } catch (e) {
      // print(e.toString());
      return null;
    }

  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

}