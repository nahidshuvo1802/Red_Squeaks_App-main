import 'dart:convert';

MyVideoFeedModel myVideoFeedModelFromJson(String str) =>
    MyVideoFeedModel.fromJson(json.decode(str));

String myVideoFeedModelToJson(MyVideoFeedModel data) =>
    json.encode(data.toJson());

class MyVideoFeedModel {
  final bool? success;
  final String? message;
  final MyVideoFeedData? data;

  MyVideoFeedModel({
    this.success,
    this.message,
    this.data,
  });

  factory MyVideoFeedModel.fromJson(Map<String, dynamic> json) =>
      MyVideoFeedModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : MyVideoFeedData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class MyVideoFeedData {
  final Meta? meta;
  final List<MyVideoFeed>? myVideoFeeds;

  MyVideoFeedData({
    this.meta,
    this.myVideoFeeds,
  });

  factory MyVideoFeedData.fromJson(Map<String, dynamic> json) =>
      MyVideoFeedData(
        meta: json["meta"] == null
            ? null
            : Meta.fromJson(json["meta"] as Map<String, dynamic>),
        myVideoFeeds: json["mysocialFeeds"] == null
            ? []
            : List<MyVideoFeed>.from(
                (json["mysocialFeeds"] as List)
                    .map((x) => MyVideoFeed.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "mysocialFeeds": myVideoFeeds == null
            ? []
            : List<dynamic>.from(myVideoFeeds!.map((x) => x.toJson())),
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

class MyVideoFeed {
  final String? id;
  final String? videoUrl;
  final String? title;
  final int? like;
  final int? dislike;
  final int? share;
  final FeedUser? user;
  final bool? isLike;
  final bool? isDislike;
  String? thumbnail; // thumbnail path or URL

  MyVideoFeed({
    this.id,
    this.videoUrl,
    this.title,
    this.like,
    this.dislike,
    this.share,
    this.user,
    this.isLike,
    this.isDislike,
    this.thumbnail,
  });

  factory MyVideoFeed.fromJson(Map<String, dynamic> json) => MyVideoFeed(
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
        "thumbnail": thumbnail,
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
