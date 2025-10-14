class MyVideoFeed {
  final String? id;
  final String? videoUrl;
  final String? title;
  final int? like;
  final DateTime? createdAt;
  String? thumbnail; // ✅ Add this for thumbnail path

  MyVideoFeed({
    this.id,
    this.videoUrl,
    this.title,
    this.like,
    this.createdAt,
    this.thumbnail,
  });

  factory MyVideoFeed.fromJson(Map<String, dynamic> json) => MyVideoFeed(
        id: json["_id"] as String?,
        videoUrl: json["videoUrl"] as String?,
        title: json["title"] as String?,
        like: json["like"] as int?,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"] as String),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "videoUrl": videoUrl,
        "title": title,
        "like": like,
        "createdAt": createdAt?.toIso8601String(),
        "thumbnail": thumbnail,
      };
}
