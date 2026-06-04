import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker;

  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  Future<File?> pickFromGallery({int imageQuality = 80}) async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    return xFile != null ? File(xFile.path) : null;
  }

  Future<File?> pickFromCamera({int imageQuality = 80}) async {
    final xFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    return xFile != null ? File(xFile.path) : null;
  }

  Future<List<File>> pickMultipleImages({int imageQuality = 80}) async {
    final xFiles = await _picker.pickMultiImage(imageQuality: imageQuality);
    return xFiles.map((f) => File(f.path)).toList();
  }

  Future<File?> pickVideo({ImageSource source = ImageSource.gallery}) async {
    final xFile = await _picker.pickVideo(source: source);
    return xFile != null ? File(xFile.path) : null;
  }
}
