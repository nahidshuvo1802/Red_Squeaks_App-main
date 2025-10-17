// models/social_profile_model.dart
class SocialProfileModel {
  final bool success;
  final String message;
  final ProfileData? data;

  SocialProfileModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SocialProfileModel.fromJson(Map<String, dynamic> json) {
    return SocialProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class ProfileData {
  final Meta? meta;
  final List<UserVideo> allVideos;

  ProfileData({this.meta, required this.allVideos});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final list = (json['allVideos'] as List? ?? [])
        .map((e) => UserVideo.fromJson(e))
        .toList();
    return ProfileData(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      allVideos: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'meta': meta?.toJson(),
        'allVideos': allVideos.map((e) => e.toJson()).toList(),
      };
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json['page'] ?? 1,
        limit: json['limit'] ?? 10,
        total: json['total'] ?? 0,
        totalPage: json['totalPage'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'totalPage': totalPage,
      };
}

class UserVideo {
  final String id;
  final UserProfile? userId;
  final String videoUrl;
  final String title;
  final int like;
  final DateTime? createdAt;

  UserVideo({
    required this.id,
    this.userId,
    required this.videoUrl,
    required this.title,
    required this.like,
    this.createdAt,
  });

  factory UserVideo.fromJson(Map<String, dynamic> json) {
    return UserVideo(
      id: json['_id'] ?? '',
      userId:
          json['userId'] != null ? UserProfile.fromJson(json['userId']) : null,
      videoUrl: json['videoUrl'] ?? '',
      title: json['title'] ?? '',
      like: json['like'] ?? 0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId?.toJson(),
        'videoUrl': videoUrl,
        'title': title,
        'like': like,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class UserProfile {
  final String id;
  final String name;
  final String photo;

  UserProfile({required this.id, required this.name, required this.photo});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'photo': photo,
      };
}
