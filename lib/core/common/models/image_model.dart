

class ImageModel {
  final String url;
  final String createdAt;

  ImageModel({
    required this.url,
    required this.createdAt,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      url: map['url'],
      createdAt: map['uploadedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'uploadedAt': createdAt,
    };
  }
}
