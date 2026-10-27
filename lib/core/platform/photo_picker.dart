import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

enum PhotoSource { camera, gallery }

/// Takes or picks a photo of a medicine strip and keeps a private copy.
abstract interface class PhotoPicker {
  /// The saved photo's path, or null if the person cancelled.
  Future<String?> pick(PhotoSource source);
}

class ImagePickerPhotoPicker implements PhotoPicker {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> pick(PhotoSource source) async {
    final file = await _picker.pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (file == null) return null;
    final dir = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/photos',
    );
    await dir.create(recursive: true);
    final target = '${dir.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';
    await File(file.path).copy(target);
    return target;
  }
}
