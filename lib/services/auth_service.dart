import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/services/database_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // sign in anonymously
  Future<void> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      throw e;
    }
  }

  User _extractUserFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? User(uId: firebaseUser.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_extractUserFromFirebaseUser);
  }

  // sign in with email & password
  Future<void> signInWithEmailAndPassword(Map<String, String> authData) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: authData['email'], password: authData['password']);
    } catch (e) {
      throw e;
    }
  }

  // sign in with Google Account
  Future<FirebaseUser> handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  // register with email and password
  Future<void> register(Map<String, String> authData) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: authData['email'], password: authData['password']);
      // create a new document for the user with uId
      await DatabaseService(uId: authResult.user.uid).updateUserData({
        'name': 'new crew member',
        'sugars': '0',
        'strength': 100,
      });
    } catch (e) {
      throw e;
    }
  }

  // sign out
  Future signOut() async {
    return await _auth.signOut();
  }
}
