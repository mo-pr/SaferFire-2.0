import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

openCamera() async {
  final image = await ImagePicker().pickImage(source: ImageSource.camera);
  uploadImage(image!);
}
openGallery() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  uploadImage(image!);
}
//https://www.educative.io/answers/how-to-upload-to-firebase-storage-with-flutter
uploadImage(XFile image) async {
  final _firebaseStorage = FirebaseStorage.instance;
  //Check Permissions
  await Permission.photos.request();

  var permissionStatus = await Permission.photos.status;

  if (permissionStatus.isGranted){
    //Select Image
    var file = File(image.path);

    if (image != null){
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref()
          .child('images/imageName')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
    } else {
      print('No Image Path Received');
    }
  } else {
    print('Permission not granted. Try Again with permission access');
  }
}