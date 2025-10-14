import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/profile_screen.dart';

class VideoController extends GetxController {
  RxBool isVideoPicking = false.obs;
  Rx<File?> selectedVideo = Rx<File?>(null);
  RxBool videoUploadLoading = false.obs;
  RxBool isVideoPicked = false.obs;

  /// ===============================
  /// 📂 Pick video from gallery
  /// ===============================
  Future<File?> pickVideoFile() async {
    try {
      isVideoPicking.value = true;

      final result = await FilePicker.platform.pickFiles(type: FileType.video);

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        selectedVideo.value = file;
        debugPrint("🎥 Selected video path: ${file.path}");
         isVideoPicked.value = true;
        return file;
      } else {
        //showCustomSnackBar("❌ No video selected", isError: true);
         isVideoPicked.value = false;
        return null;
      }
    } catch (e) {
      debugPrint("Video pick error: $e");
      isVideoPicked.value = false;
      showCustomSnackBar("⚠️ Failed to pick video", isError: true);
      return null;
    } finally {
      isVideoPicking.value = false;
    }
  }

  /// ===============================
  /// 🚀 Upload selected video + title
  /// ===============================
  Future<void> uploadVideoWithTitle({
    required String title,   // 🏷 Title text
  }) async {
    if (selectedVideo.value == null) {
      showCustomSnackBar("⚠️ Please select a video first", isError: true);
      return;
    }

    try {
      videoUploadLoading.value = true;
      refresh();

      Map<String, String> body = {
        "data": '{"title":"$title"}',
      };

      var response = await ApiClient.postMultipartData(ApiUrl.videoUpload,body,
        multipartBody: [
          MultipartBody('files', selectedVideo.value!),
        ],
      );

      debugPrint("🎬 Upload API Response: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("✅ Video uploaded successfully", isError: false);
        clearSelectedVideo();
        Get.to(ProfileScreen());
        selectedVideo.value = null;
      } else {
        showCustomSnackBar("❌ Failed to upload video", isError: true);
      }
    } catch (e) {
      debugPrint("🚨 Upload error: $e");
      showCustomSnackBar("⚠️ Error uploading video", isError: true);
    } finally {
      videoUploadLoading.value = false;
      refresh();
    }
  }

  /// ===============================
  /// 🗑️ Clear Selected Video
  /// ===============================
  void clearSelectedVideo() {
    selectedVideo.value = null;
  }
}
