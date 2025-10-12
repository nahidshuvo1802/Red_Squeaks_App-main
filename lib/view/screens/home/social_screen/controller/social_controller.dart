import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/model/social_model.dart';

class SocialFeedController extends GetxController {
  /// ===============================
  /// STATES
  /// ===============================
  RxBool isFeedLoading = false.obs;
  Rx<SocialFeedModel?> socialFeedModel = Rx<SocialFeedModel?>(null);

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
}
