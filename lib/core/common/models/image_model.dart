import '../../utils/app_strings.dart';

class ImageModel {
  final String url;
  final DateTime createdAt;

  ImageModel({
    required this.url,
    required this.createdAt,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      url: map[AppStrings.imageModelUrl],
      createdAt: map[AppStrings.imageModelUploadedAt],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppStrings.imageModelUrl: url,
      AppStrings.imageModelUploadedAt: createdAt,
    };
  }
}
