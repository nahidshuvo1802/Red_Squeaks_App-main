// models/my_record_model.dart
class MyRecordModel {
  final bool success;
  final String message;
  final MyRecordData? data;

  MyRecordModel({required this.success, required this.message, this.data});

  factory MyRecordModel.fromJson(Map<String, dynamic> json) {
    return MyRecordModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? MyRecordData.fromJson(json['data']) : null,
    );
  }
}

class MyRecordData {
  final Meta? meta;
  final List<MyRecordItem> myRecordLibrary;

  MyRecordData({this.meta, required this.myRecordLibrary});

  factory MyRecordData.fromJson(Map<String, dynamic> json) {
    var list = <MyRecordItem>[];
    if (json['myRecordLibrary'] != null) {
      list = List<Map<String, dynamic>>.from(json['myRecordLibrary'])
          .map((e) => MyRecordItem.fromJson(e))
          .toList();
    }
    return MyRecordData(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      myRecordLibrary: list,
    );
  }
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;
  Meta({required this.page, required this.limit, required this.total, required this.totalPage});
  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json['page'] ?? 1,
        limit: json['limit'] ?? 10,
        total: json['total'] ?? 0,
        totalPage: json['totalPage'] ?? 0,
      );
}

class MyRecordItem {
  final String id;
  final Map<String, dynamic>? userId;
  final String audioUrl;
  final DateTime? createdAt;

  MyRecordItem({
    required this.id,
    this.userId,
    required this.audioUrl,
    this.createdAt,
  });

  factory MyRecordItem.fromJson(Map<String, dynamic> json) {
    return MyRecordItem(
      id: json['_id'] ?? '',
      userId: json['userId'],
      audioUrl: json['audioUrl'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
