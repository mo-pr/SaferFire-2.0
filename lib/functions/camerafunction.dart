import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
openCamera() async {
  await Permission.photos.request();
  final image = await ImagePicker().pickImage(source: ImageSource.camera);
  await uploadImage(image!);
}
openGallery() async {
  await Permission.location.request();
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  await uploadImage(image!);
}
//https://www.educative.io/answers/how-to-upload-to-firebase-storage-with-flutter
uploadImage(XFile image) async {
  final _firebaseStorage = FirebaseStorage.instance;
    var file = File(image.path);

    if (image != null){
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref()
          .child('images')
          .child(p.basename(file.path))
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
    } else {
      print('No Image Path Received');
    }
}
