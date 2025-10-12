import 'dart:convert';

SocialFeedModel socialFeedModelFromJson(String str) =>
    SocialFeedModel.fromJson(json.decode(str));

String socialFeedModelToJson(SocialFeedModel data) =>
    json.encode(data.toJson());

class SocialFeedModel {
  final bool? success;
  final String? message;
  final SocialFeedData? data;

  SocialFeedModel({
    this.success,
    this.message,
    this.data,
  });

  factory SocialFeedModel.fromJson(Map<String, dynamic> json) =>
      SocialFeedModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : SocialFeedData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class SocialFeedData {
  final Meta? meta;
  final List<SocialFeed>? socialFeeds;

  SocialFeedData({
    this.meta,
    this.socialFeeds,
  });

  factory SocialFeedData.fromJson(Map<String, dynamic> json) => SocialFeedData(
        meta: json["meta"] == null
            ? null
            : Meta.fromJson(json["meta"] as Map<String, dynamic>),
        socialFeeds: json["socialFeeds"] == null
            ? []
            : List<SocialFeed>.from(
                (json["socialFeeds"] as List)
                    .map((x) => SocialFeed.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "socialFeeds": socialFeeds == null
            ? []
            : List<dynamic>.from(socialFeeds!.map((x) => x.toJson())),
      };
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"] as int?,
        limit: json["limit"] as int?,
        total: json["total"] as int?,
        totalPage: json["totalPage"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "totalPage": totalPage,
      };
}

class SocialFeed {
  final String? id;
  final String? videoUrl;
  final String? title;
  final int? like;
  final int? dislike;
  final int? share;
  final FeedUser? user;
  final bool? isLike;
  final bool? isDislike;

  SocialFeed({
    this.id,
    this.videoUrl,
    this.title,
    this.like,
    this.dislike,
    this.share,
    this.user,
    this.isLike,
    this.isDislike,
  });

  factory SocialFeed.fromJson(Map<String, dynamic> json) => SocialFeed(
        id: json["_id"] as String?,
        videoUrl: json["videoUrl"] as String?,
        title: json["title"] as String?,
        like: json["like"] as int?,
        dislike: json["dislike"] as int?,
        share: json["share"] as int?,
        user: json["user"] == null
            ? null
            : FeedUser.fromJson(json["user"] as Map<String, dynamic>),
        isLike: json["isLike"] as bool?,
        isDislike: json["isDislike"] as bool?,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "videoUrl": videoUrl,
        "title": title,
        "like": like,
        "dislike": dislike,
        "share": share,
        "user": user?.toJson(),
        "isLike": isLike,
        "isDislike": isDislike,
      };
}

class FeedUser {
  final String? name;
  final String? photo;

  FeedUser({
    this.name,
    this.photo,
  });

  factory FeedUser.fromJson(Map<String, dynamic> json) => FeedUser(
        name: json["name"] as String?,
        photo: json["photo"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "photo": photo,
      };
}
