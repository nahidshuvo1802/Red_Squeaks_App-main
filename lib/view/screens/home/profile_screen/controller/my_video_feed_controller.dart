import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/model/my_feed_video_model.dart';
import 'package:share_plus/share_plus.dart';

class MyVideoFeedController extends GetxController {
  /// ===============================
  /// STATES
  /// ===============================
  RxBool isFeedLoading = false.obs;
  Rx<MyVideoFeedModel?> myVideoFeedModel = Rx<MyVideoFeedModel?>(null);

  var myVideos = <MyVideoFeed>[].obs; // reactive list of videos
  var likedPosts = <String, bool>{}.obs;
  var dislikedPosts = <String, bool>{}.obs;
  var sharedPosts = <String, bool>{}.obs;

  var postLikeCounts = <String, int>{}.obs;
  var postDislikeCounts = <String, int>{}.obs;

  /// ===============================
  /// GET ALL MY VIDEOS
  /// ===============================
  Future<void> getMyVideos() async {
    try {
      isFeedLoading.value = true;
      debugPrint("📡 [GET VIDEOS] Fetching my video feed data...");

      final response = await ApiClient.getData(ApiUrl.getAllMyVideos);

      // ✅ response.body ke JSON map e decode koro
      Map<String, dynamic> jsonMap;
      if (response.body is String) {
        jsonMap = json.decode(response.body);
      } else if (response.body is Map<String, dynamic>) {
        jsonMap = response.body;
      } else {
        debugPrint("❌ Unknown response type: ${response.body.runtimeType}");
        return;
      }

      // ✅ Model e parse koro
      myVideoFeedModel.value = MyVideoFeedModel.fromJson(jsonMap);

      // ✅ List update
      myVideos.value = myVideoFeedModel.value?.data?.myVideoFeeds ?? [];

      debugPrint(
          "✅ Fetched ${myVideos.length} videos successfully.");

    } catch (e) {
      debugPrint("💥 [EXCEPTION] My video feed load error: $e");
      showCustomSnackBar("Something went wrong while loading my videos!");
    } finally {
      isFeedLoading.value = false;
    }
  }

  /// ===============================
  /// LIKE VIDEO
  /// ===============================
  Future<void> likeVideo(String videoId) async {
    bool isLiked = likedPosts[videoId] ?? false;
    bool isDisliked = dislikedPosts[videoId] ?? false;

    likedPosts[videoId] = !isLiked;

    if (likedPosts[videoId]! && isDisliked) {
      dislikedPosts[videoId] = false;
    }

    if (likedPosts[videoId]!) {
      postLikeCounts[videoId] = (postLikeCounts[videoId] ?? 0) + 1;
    } else {
      postLikeCounts[videoId] = (postLikeCounts[videoId] ?? 1) - 1;
    }

    update();

    final body = {"videofileId": videoId};
    try {
      final response =
          await ApiClient.postData(ApiUrl.isLikeReact, jsonEncode(body));

      if (response.statusCode != 200) {
        likedPosts[videoId] = isLiked;
        postLikeCounts[videoId] = (postLikeCounts[videoId] ?? 1) - 1;
        update();
      }
    } catch (e) {
      likedPosts[videoId] = isLiked;
      postLikeCounts[videoId] = (postLikeCounts[videoId] ?? 1) - 1;
      update();
    }
  }

  /// ===============================
  /// DISLIKE VIDEO
  /// ===============================
  Future<void> dislikeVideo(String videoId) async {
    bool isLiked = likedPosts[videoId] ?? false;
    bool isDisliked = dislikedPosts[videoId] ?? false;

    dislikedPosts[videoId] = !isDisliked;

    if (dislikedPosts[videoId]! && isLiked) {
      likedPosts[videoId] = false;
    }

    if (dislikedPosts[videoId]!) {
      postDislikeCounts[videoId] = (postDislikeCounts[videoId] ?? 0) + 1;
    } else {
      postDislikeCounts[videoId] = (postDislikeCounts[videoId] ?? 1) - 1;
    }

    update();

    final body = {"videofileId": videoId};
    try {
      final response =
          await ApiClient.postData(ApiUrl.isDislikeReact, jsonEncode(body));

      if (response.statusCode != 200) {
        dislikedPosts[videoId] = isDisliked;
        postDislikeCounts[videoId] =
            (postDislikeCounts[videoId] ?? 1) - 1;
        update();
      }
    } catch (e) {
      dislikedPosts[videoId] = isDisliked;
      postDislikeCounts[videoId] =
          (postDislikeCounts[videoId] ?? 1) - 1;
      update();
    }
  }

  /// ===============================
  /// SHARE VIDEO
  /// ===============================
  Future<void> shareVideo(String videoUrl, String videoId) async {
    try {
      final shareText = "🎬 Check out this video:\n$videoUrl";
      await Share.share(shareText, subject: "Watch this awesome video!");

      // update shared status
      await sharePost(videoId);
    } catch (e) {
      debugPrint("❌ Share failed: $e");
      showCustomSnackBar("Failed to share video!");
    }
  }

  /// ===============================
  /// SHARE POST API
  /// ===============================
  Future<void> sharePost(String videoId) async {
    sharedPosts[videoId] = true;
    update();

    final body = {"videofileId": videoId};
    try {
      await ApiClient.postData(ApiUrl.isShare, jsonEncode(body));
    } catch (e) {
      sharedPosts[videoId] = false;
      update();
    }
  }

  /// ===============================
  /// RESET ALL STATES
  /// ===============================
  void resetReactions() {
    likedPosts.clear();
    dislikedPosts.clear();
    sharedPosts.clear();
    postLikeCounts.clear();
    postDislikeCounts.clear();
  }
}
