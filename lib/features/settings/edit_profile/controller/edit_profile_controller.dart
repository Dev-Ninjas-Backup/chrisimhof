import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } on Exception catch (e) {
      if (e.toString().contains('channel-error')) {
        Get.snackbar(
          'Error',
          'Image picker channel error. Run: flutter clean && flutter pub get',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
