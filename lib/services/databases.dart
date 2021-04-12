import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myapp/Model/UserInfor.dart';
import 'package:myapp/enum/user_state.dart';
import 'package:myapp/helper/strings.dart';
import 'package:path_provider/path_provider.dart';

class databaseMethods {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _messageCollection =
      _firestore.collection("ChatRoom");
  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);
  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<List<UserInfor>> fetchAllUsers(User user) async {
    // ignore: deprecated_member_use
    List<UserInfor> userList = List<UserInfor>();

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userList.add(UserInfor.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  addToContacts({String senderId, String reciverId}) async {}
  GetUserbyUsername(String Username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: Username)
        .get();
  }

  GetUser() async {
    return await FirebaseFirestore.instance.collection("users").get();
  }

  UploadUserInfor(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e);
    });
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    PickedFile selectedImage = await ImagePicker().getImage(source: source);
    File file = File(selectedImage.path);
    return await compressImage(file);
  }

  Future<UserInfor> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();
    return UserInfor.fromMap(documentSnapshot.data());
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(1000);
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);
    return new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');

    return formatter.format(dateTime);
  }
}
