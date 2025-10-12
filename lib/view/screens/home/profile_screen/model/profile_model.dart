import 'dart:convert';

MyProfileModel myProfileModelFromJson(String str) =>
    MyProfileModel.fromJson(json.decode(str));

String myProfileModelToJson(MyProfileModel data) =>
    json.encode(data.toJson());

class MyProfileModel {
  final bool? success;
  final String? message;
  final ProfileData? data;

  MyProfileModel({
    this.success,
    this.message,
    this.data,
  });

  factory MyProfileModel.fromJson(Map<String, dynamic> json) => MyProfileModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : ProfileData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class ProfileData {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? photo;

  ProfileData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.photo,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["_id"] ?? json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "photo": photo,
      };
}
