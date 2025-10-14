import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/model/my_video_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class MyVideoController extends GetxController {
  /// ===============================
  /// STATES
  /// ===============================
  RxBool isLoading = false.obs;
  var myVideos = <MyVideoFeed>[].obs;
  var sharedVideos = <String, bool>{}.obs;

  /// ===============================
  /// FETCH ALL MY VIDEOS
  /// ===============================
  Future<void> getAllMyVideos() async {
    try {
      isLoading.value = true;
      debugPrint("📡 Fetching all my videos...");

      final response = await ApiClient.getData(ApiUrl.getAllMyVideos);
      final List<dynamic> videos = response.body['data']['mysocialFeeds'] ?? [];

      myVideos.value = videos
          .map((e) => MyVideoFeed.fromJson(e as Map<String, dynamic>))
          .toList();

      // 🎞️ Generate thumbnail for each video
     for (int i = 0; i < myVideos.length; i++) {
  final video = myVideos[i];
  if (video.videoUrl != null && video.videoUrl!.isNotEmpty) {
    await Future.delayed(const Duration(milliseconds: 300)); // 🔹 avoids overload
    final thumb = await generateVideoThumbnail(video.videoUrl!);
    if (thumb != null) {
      video.thumbnail = thumb;
      myVideos[i] = video;
    }
  }
}

      debugPrint("✅ ${myVideos.length} videos fetched successfully!");
    } catch (e) {
      debugPrint("💥 getAllMyVideos error: $e");
      showCustomSnackBar("Failed to load videos!");
    } finally {
      isLoading.value = false;
    }
  }

  //=================Generate Thumbnail===============
  Future<String?> generateVideoThumbnail(String videoUrl) async {
    try {
      // ✅ Ensure full video URL
      final fullUrl = videoUrl.startsWith('http')
          ? videoUrl
          : "${ApiUrl.baseUrl}/$videoUrl";

      // ✅ Create a temp folder
      final tempDir = await getTemporaryDirectory();
      final tempVideoPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      final tempVideoFile = File(tempVideoPath);

      // ✅ Download the video (just for thumbnail)
      final response = await http.get(Uri.parse(fullUrl));
      await tempVideoFile.writeAsBytes(response.bodyBytes);

      // ✅ Generate a lightweight thumbnail (to avoid OOM)
      final thumbPath = await VideoThumbnail.thumbnailFile(
        video: tempVideoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 120, // keep this low for performance
        quality: 30, // low quality = less memory
      );

      // ✅ Cleanup: delete temp video to free memory
      await tempVideoFile.delete();

      debugPrint("🎞️ Thumbnail created: $thumbPath");
      return thumbPath;
    } catch (e, st) {
      debugPrint("❌ Thumbnail generation failed: $e");
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  /// ===============================
  /// DELETE VIDEO
  /// ===============================
  Future<void> deleteVideo(String videoId) async {
    try {
      myVideos.removeWhere((video) => video.id == videoId);

      final body = {"videofileId": videoId};
      await ApiClient.postData(
        ApiUrl.deleteVideo(videoId: videoId),
        jsonEncode(body),
      );

      showCustomSnackBar("Video deleted successfully!");
    } catch (e) {
      debugPrint("💥 deleteVideo error: $e");
      showCustomSnackBar("Failed to delete video!");
    }
  }

  /// ===============================
  /// SHARE VIDEO
  /// ===============================
  Future<void> shareVideo(String videoUrl, String videoId) async {
    try {
      final shareText = "🎬 Check out this video:\n$videoUrl";
      await Share.share(shareText, subject: "Watch this awesome video!");
      sharePost(videoId);
    } catch (e) {
      debugPrint("❌ Share failed: $e");
      showCustomSnackBar("Failed to share video!");
    }
  }

  /// ===============================
  /// SHARE POST API
  /// ===============================
  Future<void> sharePost(String videoId) async {
    sharedVideos[videoId] = true;
    update();
    final body = {"videofileId": videoId};

    try {
      await ApiClient.postData(ApiUrl.isShare, jsonEncode(body));
    } catch (e) {
      sharedVideos[videoId] = false;
      update();
    }
  }

  /// ===============================
  /// RESET STATES
  /// ===============================
  void resetAll() {
    myVideos.clear();
    sharedVideos.clear();
  }
}
