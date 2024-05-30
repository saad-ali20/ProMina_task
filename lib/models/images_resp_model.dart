// To parse this JSON data, do
//
//     final imagesResponseModel = imagesResponseModelFromJson(jsonString);

import 'dart:convert';

ImagesResponseModel imagesResponseModelFromJson(String str) =>
    ImagesResponseModel.fromJson(json.decode(str));

String imagesResponseModelToJson(ImagesResponseModel data) =>
    json.encode(data.toJson());

class ImagesResponseModel {
  String status;
  Data data;
  String message;

  ImagesResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ImagesResponseModel.fromJson(Map<String, dynamic> json) =>
      ImagesResponseModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  List<String> images;

  Data({
    required this.images,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
