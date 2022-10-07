import 'package:image_picker/image_picker.dart';

openCamera() async {
  final image = await ImagePicker().pickImage(source: ImageSource.camera);
}
openGallery() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
}
