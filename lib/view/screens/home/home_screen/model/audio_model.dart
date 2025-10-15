// lib/view/screens/home/model/audio_upload_model.dart
class AudioUploadResponse {
  final String? message;
  final List<String>? uploadedUrls;

  AudioUploadResponse({this.message, this.uploadedUrls});

  factory AudioUploadResponse.fromJson(Map<String, dynamic> json) {
    return AudioUploadResponse(
      message: json['message'],
      uploadedUrls: (json['files'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
