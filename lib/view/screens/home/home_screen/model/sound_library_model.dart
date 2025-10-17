// models/live_event_model.dart
class SoundLibraryModel {
  final bool success;
  final String message;
  final LiveEventData? data;

  SoundLibraryModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SoundLibraryModel.fromJson(Map<String, dynamic> json) {
    return SoundLibraryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? LiveEventData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class LiveEventData {
  final Meta? meta;
  final List<LiveEventItem> liveEvent;

  LiveEventData({
    this.meta,
    required this.liveEvent,
  });

  factory LiveEventData.fromJson(Map<String, dynamic> json) {
    var list = <LiveEventItem>[];
    if (json['liveEvent'] != null) {
      list = List<Map<String, dynamic>>.from(json['liveEvent'])
          .map((e) => LiveEventItem.fromJson(e))
          .toList();
    }
    return LiveEventData(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      liveEvent: list,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta?.toJson(),
      'liveEvent': liveEvent.map((e) => e.toJson()).toList(),
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}

class LiveEventItem {
  final String id;
  final String audioUrl;
  final DateTime? createdAt;

  LiveEventItem({
    required this.id,
    required this.audioUrl,
    this.createdAt,
  });

  factory LiveEventItem.fromJson(Map<String, dynamic> json) {
    return LiveEventItem(
      id: json['_id'] ?? json['id'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'audioUrl': audioUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}