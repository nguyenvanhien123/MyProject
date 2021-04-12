import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/Model/UserInfor.dart';
import 'package:myapp/provider/image_upload_provider.dart';
import 'package:myapp/services/chat_methods.dart';

class StorageMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference reference;
  //user class
  UserInfor user = UserInfor();
  String imageurl;
  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      reference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask storageUploadTask = reference.putFile(imageFile);
      var url = await (await storageUploadTask).ref.getDownloadURL();
      imageurl = url.toString();
      return imageurl;
    } catch (e) {
      return null;
    }
  }

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }
}
