class ImageModel {
  final String url;
  // final dynamic url;
  final int imgIndex;

  ImageModel({required this.url, required this.imgIndex});

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        url: json["url"],
        imgIndex: json["imgIndex"],
      );
}
