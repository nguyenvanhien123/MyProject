import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/Model/UserInfor.dart';
import 'package:myapp/Model/User_Account.dart';
import 'package:myapp/enum/user_state.dart';
import 'package:myapp/helper/constants.dart';
import 'package:myapp/helper/strings.dart';
import 'package:myapp/services/databases.dart';

class AuthMethods {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  databaseMethods _database = databaseMethods();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CollectionReference _userCollection =
      firestore.collection(USERS_COLLECTION);
  UserAccount _userAccount(User user) {
    return user != null ? UserAccount(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user1 = userCredential.user;
      return _userAccount(user1);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> authenticateUser(UserCredential user) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(UserCredential currentUser) async {
    String username = databaseMethods.getUsername(currentUser.user.email);

    UserInfor user = UserInfor(
        uid: currentUser.user.uid,
        email: currentUser.user.email,
        name: currentUser.user.displayName,
        profilePhoto: currentUser.user.photoURL,
        username: username);

    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.user.uid)
        .set(user.toMap(user));
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      UserCredential user = await _auth.signInWithCredential(credential);
      return user;
    } catch (e) {
      print("Auth methods error");
      print(e);
      return null;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = databaseMethods.stateToNum(userState);

    _userCollection.doc(userId).update({
      "state": stateNum,
    });
  }

  Future<UserInfor> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      return UserInfor.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.doc(uid).snapshots();

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return _userAccount(user);
    } catch (e) {
      print(e);
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> signOut() async {
    Constants.MyName = "";
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
