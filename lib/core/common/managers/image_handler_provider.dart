import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/app_setup.dart';
import '../../services/api_services.dart';
import '../../services/logger.dart';
import '../../utils/app_strings.dart';

class ImageHandlerProvider extends ChangeNotifier {
  ImageHandlerProvider() {
    Logger.logEvent(
      className: 'ImageHandlerProvider',
      event: 'Provider Created',
    );
  }

  final ImagePicker _picker = ImagePicker();

  static Future<String> uploadImageAndGetUrl(File imageFile) async {
    final ApiServices apiServices = getIt<ApiServices>();
    try {
      final String? imageUrl = await apiServices.uploadFile(
        endPoint: AppStrings.apiUploadImageUrl,
        data: imageFile,
      );

      return imageUrl ?? '';
    } catch (e) {
      Logger.logEvent(
        className: 'ImageHandlerProvider',
        event: 'Error uploading image: $e',
        methodName: 'uploadImage',
      );
      rethrow;
    }
  }

  // local methods
  Future<File?> pickImage({
    required BuildContext context,
    required ImageSource imageSource,
  }) async {
    final File? pickedFile = await _handleImage(context, imageSource);

    return pickedFile;
  }

  // private methods
  Future<File?> _handleImage(context, ImageSource imageSource) async {
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile == null) return null;
    final File? croppedFile = await _cropImage(pickedFile);
    return croppedFile;
  }

  Future<File?> _cropImage(XFile imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 16.0, ratioY: 9.0),
      uiSettings: <PlatformUiSettings>[
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }
}
