import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/profile_screen.dart';

class VideoController extends GetxController {
  RxBool isVideoPicking = false.obs;
  Rx<File?> selectedVideo = Rx<File?>(null);
  RxBool videoUploadLoading = false.obs;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  /// ===============================
  /// 📂 Pick video from gallery
  /// ===============================
  Future<void> pickVideoFile() async {
    try {
      isVideoPicking.value = true;

      final result = await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        selectedVideo.value = file;

        // 🎬 Initialize preview
        await initializeVideoPlayer(file);
      } else {
        showCustomSnackBar("❌ No video selected", isError: true);
      }
    } catch (e) {
      debugPrint("Video pick error: $e");
      showCustomSnackBar("⚠️ Failed to pick video", isError: true);
    } finally {
      isVideoPicking.value = false;
    }
  }

  /// 🎥 Initialize video preview
  Future<void> initializeVideoPlayer(File file) async {
    videoPlayerController = VideoPlayerController.file(file);
    await videoPlayerController!.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: false,
      looping: false,
      aspectRatio: videoPlayerController!.value.aspectRatio,
    );
    update();
  }

  /// ===============================
  /// 🚀 Upload selected video + title
  /// ===============================
  Future<void> uploadVideoWithTitle({required String title}) async {
    if (selectedVideo.value == null) {
      showCustomSnackBar("⚠️ Please select a video first", isError: true);
      return;
    }

    try {
      videoUploadLoading.value = true;

      Map<String, String> body = {"data": '{"title":"$title"}'};

      var response = await ApiClient.postMultipartData(
        ApiUrl.videoUpload,
        body,
        multipartBody: [MultipartBody('files', selectedVideo.value!)],
      );

      debugPrint("🎬 Upload Response: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("✅ Video uploaded successfully", isError: false);
        clearSelectedVideo();
        Get.to(ProfileScreen());
      } else {
        showCustomSnackBar("❌ Failed to upload video", isError: true);
      }
    } catch (e) {
      debugPrint("🚨 Upload error: $e");
      showCustomSnackBar("⚠️ Error uploading video", isError: true);
    } finally {
      videoUploadLoading.value = false;
    }
  }

  /// ===============================
  /// 🗑️ Clear Selected Video
  /// ===============================
  void clearSelectedVideo() {
    selectedVideo.value = null;
    videoPlayerController?.dispose();
    chewieController?.dispose();
  }
}
