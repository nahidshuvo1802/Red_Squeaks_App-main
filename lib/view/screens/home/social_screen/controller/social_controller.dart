import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/model/social_model.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/model/social_profile_model.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/widget/custom_social_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SocialFeedController extends GetxController {
  /// ===============================
  /// STATES
  /// ===============================
  RxBool isFeedLoading = false.obs;
  Rx<SocialFeedModel?> socialFeedModel = Rx<SocialFeedModel?>(null);
  RxBool isLiked = false.obs;
  RxBool isDisLiked = false.obs;
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
      if (response.body is Map<String, dynamic>) {
        socialFeedModel.value =
            SocialFeedModel.fromJson(response.body as Map<String, dynamic>);
      } else if (response.body is String) {
        socialFeedModel.value =
            socialFeedModelFromJson(response.body as String);
      } else {
        debugPrint("❌ [ERROR] Unknown response type: ${response.runtimeType}");
      }

      // 🔹 Debug prints
      if (socialFeedModel.value != null &&
          socialFeedModel.value?.data?.socialFeeds?.isNotEmpty == true) {
        final firstFeed = socialFeedModel.value!.data!.socialFeeds!.first;
        debugPrint("✅ [SUCCESS] Feeds: "
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

  /// ===============================
  /// LIKE A POST
  /// ===============================
  Future<void> likePost(String postId) async {
    bool wasLiked = likedPosts[postId] ?? false;
    bool wasDisliked = dislikedPosts[postId] ?? false;

    // Toggle like
    likedPosts[postId] = !wasLiked;

    // Undo dislike if liked
    if (likedPosts[postId]! && wasDisliked) {
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
        // Rollback
        likedPosts[postId] = wasLiked;
        postLikeCounts[postId] = (postLikeCounts[postId] ?? 1) - 1;
        update();
      }
    } catch (e) {
      // Rollback on error
      likedPosts[postId] = wasLiked;
      postLikeCounts[postId] = (postLikeCounts[postId] ?? 1) - 1;
      update();
    }
  }

  /// ===============================
  /// DISLIKE A POST
  /// ===============================
  Future<void> dislikePost(String postId) async {
    bool wasLiked = likedPosts[postId] ?? false;
    bool wasDisliked = dislikedPosts[postId] ?? false;

    // Toggle dislike
    dislikedPosts[postId] = !wasDisliked;

    // Undo like if disliked
    if (dislikedPosts[postId]! && wasLiked) {
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
        // Rollback
        dislikedPosts[postId] = wasDisliked;
        postDislikeCounts[postId] = (postDislikeCounts[postId] ?? 1) - 1;
        update();
      }
    } catch (e) {
      // Rollback on error
      dislikedPosts[postId] = wasDisliked;
      postDislikeCounts[postId] = (postDislikeCounts[postId] ?? 1) - 1;
      update();
    }
  }

  /// ===============================
  /// SHARE VIDEO (Local Share + API)
  /// ===============================
  Future<void> shareVideo(String videoUrl) async {
    try {
      final shareText = "🎬 Check out this video:\n$videoUrl";
      await Share.share(shareText, subject: "Watch this awesome video!");

      // ✅ Optional API call for share count
      await sharePost(videoUrl);
    } catch (e) {
      debugPrint("❌ Share failed: $e");
    }
  }

  /// ===============================
  /// SHARE POST API
  /// ===============================
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

  /// ===============================
  /// GET USER PROFILE BY ID
  /// ===============================
  RxBool isUserProfileLoading = false.obs;
  RxList<UserVideo> userProfileVideos = <UserVideo>[].obs;
  Rx<UserProfile?> userInfo = Rx<UserProfile?>(null);

  Future<void> getUserProfile(String userId) async {
    try {
      isUserProfileLoading.value = true;
      debugPrint("📡 [GET USER PROFILE] Fetching data for user ID: $userId");

      final response =
          await ApiClient.getData(ApiUrl.getSocialProfilebyId(id: userId));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        final profileModel = SocialProfileModel.fromJson(jsonData);

        if (profileModel.success && profileModel.data != null) {
          userProfileVideos.assignAll(profileModel.data!.allVideos);
          if (profileModel.data!.allVideos.isNotEmpty) {
            userInfo.value = profileModel.data!.allVideos.first.userId;
          }
          debugPrint(
              "✅ [SUCCESS] ${profileModel.data!.allVideos.length} videos fetched for ${userInfo.value?.name ?? 'Unknown User'}");
        } else {
          userProfileVideos.clear();
          debugPrint("⚠️ [INFO] No videos found for this user.");
        }
      } else {
        debugPrint(
            "❌ [ERROR] Failed to fetch user profile. Status: ${response.statusCode}");
        showCustomSnackBar("Failed to fetch user profile.");
      }
    } catch (e) {
      debugPrint("💥 [EXCEPTION] User profile fetch error: $e");
      showCustomSnackBar("Something went wrong while fetching profile.");
    } finally {
      isUserProfileLoading.value = false;
    }
  }

  /// Generate a video thumbnail from a video URL
Future<String?> generateThumbnail(String videoUrl) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 200, // thumbnail height
      quality: 75,
    );
    return thumbnailPath; // local file path to the generated image
  } catch (e) {
    debugPrint("❌ Thumbnail generation failed: $e");
    return null;
  }
}

  /// ===============================
  /// RESET REACTIONS
  /// ===============================
  void resetReactions() {
    likedPosts.clear();
    dislikedPosts.clear();
    sharedPosts.clear();
    postLikeCounts.clear();
    postDislikeCounts.clear();
  }
}
