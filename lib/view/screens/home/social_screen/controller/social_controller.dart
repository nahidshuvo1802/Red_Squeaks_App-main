import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/model/social_model.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/widget/custom_social_card.dart';
import 'package:share_plus/share_plus.dart';

class SocialFeedController extends GetxController {
  /// ===============================
  /// STATES
  /// ===============================
  RxBool isFeedLoading = false.obs;
  Rx<SocialFeedModel?> socialFeedModel = Rx<SocialFeedModel?>(null);
  RxBool isLiked = false.obs;
  RxBool isdisLiked = false.obs;
  RxBool isShared = false.obs;

  var likedPosts = <String, bool>{}.obs;
  var dislikedPosts = <String, bool>{}.obs;
  var sharedPosts = <String, bool>{}.obs;

  var postLikeCounts = <String, int>{}.obs;
  var postDislikeCounts = <String, int>{}.obs;

  /// ===============================
  /// GET ALL SOCIAL FEEDS API
  /// ===============================
  Future<void> getSocialFeeds() async {
    try {
      isFeedLoading.value = true;
      debugPrint("📡 [GET FEEDS] Fetching social feed data...");

      final response = await ApiClient.getData(ApiUrl.getAllSocialFeeds);

      // 🔹 Different response formats handled safely
      if (response is Map<String, dynamic>) {
        socialFeedModel.value = SocialFeedModel.fromJson(response.body);
      } else if (response is String) {
        socialFeedModel.value = socialFeedModelFromJson(response.body);
      } else if (response.body is String) {
        socialFeedModel.value = socialFeedModelFromJson(response.body);
      } else if (response.body is Map<String, dynamic>) {
        socialFeedModel.value =
            SocialFeedModel.fromJson(response.body as Map<String, dynamic>);
      } else {
        debugPrint("❌ [ERROR] Unknown response type: ${response.runtimeType}");
      }

      // 🔹 Debug prints
      if (socialFeedModel.value != null &&
          socialFeedModel.value?.data?.socialFeeds?.isNotEmpty == true) {
        final firstFeed = socialFeedModel.value!.data!.socialFeeds!.first;
        debugPrint("✅ [SUCCESS] Fetched Feeds: "
            "${socialFeedModel.value!.data!.socialFeeds!.length}");
        debugPrint("🎬 First video title: ${firstFeed.title}");
        debugPrint("🌐 Video URL: ${firstFeed.videoUrl}");
      } else {
        debugPrint("⚠️ [INFO] No feeds found.");
      }
    } catch (e) {
      debugPrint("💥 [EXCEPTION] Social feed load error: $e");
      showCustomSnackBar("Something went wrong while loading feeds!");
    } finally {
      isFeedLoading.value = false;
    }
  }

  //===============like button=============
  /// ===============================
  /// LIKE A POST API
  /// ===============================

  Future<void> likePost(String postId) async {
    bool isLiked = likedPosts[postId] ?? false;
    bool isDisliked = dislikedPosts[postId] ?? false;

    // Toggle like
    likedPosts[postId] = !isLiked;

    // Undo dislike if liked
    if (likedPosts[postId]! && isDisliked) {
      dislikedPosts[postId] = false;
    }

    // Update like count
    if (likedPosts[postId]!) {
      postLikeCounts[postId] = (postLikeCounts[postId] ?? 0) + 1;
    } else {
      postLikeCounts[postId] = (postLikeCounts[postId] ?? 1) - 1;
    }

    update();
    final body = {"videofileId": postId};

    try {
      final response =
          await ApiClient.postData(ApiUrl.isLikeReact, jsonEncode(body));

      if (response.statusCode != 200) {
        // যদি fail করে, rollback করো
        likedPosts[postId] = isLiked;
        postLikeCounts[postId] = (postLikeCounts[postId] ?? 1) - 1;
        update();
      }
    } catch (e) {
      // Network error হলে rollback করো
      likedPosts[postId] = isLiked;
      postLikeCounts[postId] = (postLikeCounts[postId] ?? 1) - 1;
      update();
    }
  }

  ///////////////////=============Dislike Post================/////////////////////

  Future<void> dislikePost(String postId) async {
    bool isLiked = likedPosts[postId] ?? false;
    bool isDisliked = dislikedPosts[postId] ?? false;

    // Toggle dislike
    dislikedPosts[postId] = !isDisliked;

    // Undo like if disliked
    if (dislikedPosts[postId]! && isLiked) {
      likedPosts[postId] = false;
    }

    // Update dislike count
    if (dislikedPosts[postId]!) {
      postDislikeCounts[postId] = (postDislikeCounts[postId] ?? 0) + 1;
    } else {
      postDislikeCounts[postId] = (postDislikeCounts[postId] ?? 1) - 1;
    }

    update();
    final body = {"videofileId": postId};

    try {
      final response =
          await ApiClient.postData(ApiUrl.isDislikeReact, jsonEncode(body));

      if (response.statusCode != 200) {
        // যদি fail করে, rollback করো
        dislikedPosts[postId] = isLiked;
        postLikeCounts[postId] = (postLikeCounts[postId] ?? 1) - 1;
        update();
      }
    } catch (e) {
      // Network error হলে rollback করো
      likedPosts[postId] = isLiked;
      postLikeCounts[postId] = (postLikeCounts[postId] ?? 1) - 1;
      update();
    }
  }
  //share Video =================
Future<void> shareVideo(videourl) async {
  try {
    final videoUrl = videourl;
    final shareText = "🎬 Check out this video:\n$videoUrl";
    print("${shareText}");
    // ignore: deprecated_member_use
    await Share.share(shareText, subject: "Watch this awesome video!");
    
    // ✅ চাইলে এখানে share count update / API call করতে পারো
    controller.sharePost(videourl);
  } catch (e) {
    debugPrint("❌ Share failed: $e");
  }
}
///////////////////=============Share Post================///////////////////////
  Future<void> sharePost(String postId) async {
    sharedPosts[postId] = true;
    update();
    final body = {"videofileId": postId};

    try {
      await ApiClient.postData(ApiUrl.isShare, jsonEncode(body));
    } catch (e) {
      sharedPosts[postId] = false;
    }
    update();
  }

//Reset All=============================
  void resetReactions() {
    likedPosts.clear();
    dislikedPosts.clear();
    sharedPosts.clear();
    postLikeCounts.clear();
    postDislikeCounts.clear();
  }
}
