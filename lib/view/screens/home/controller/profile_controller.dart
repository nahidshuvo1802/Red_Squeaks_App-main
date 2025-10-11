import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/helper/shared_prefe/shared_prefe.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/utils/app_const/app_const.dart';
import 'package:hide_and_squeaks/view/screens/home/model/profile_model.dart';

class ProfileController extends GetxController {
  /// ===============================
  /// STATES
  /// ===============================
  RxBool isProfileLoading = false.obs;
  Rx<MyProfileModel?> profileModel = Rx<MyProfileModel?>(null);

  /// ===============================
  /// GET MY PROFILE API
  /// ===============================
  Future<void> getProfile() async {
    isProfileLoading.value = true;

    try {
      // 🔹 Get token from SharedPrefs
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);

      // 🔹 Call API
      final response = await ApiClient.getData(ApiUrl.getMyProfile);

      isProfileLoading.value = false;

      // 🔹 Check response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        profileModel.value = MyProfileModel.fromJson(decoded);
        debugPrint("✅ Profile Loaded: ${profileModel.value?.data?.name}");
      } else {
        final msg = response.body['message'] ?? "Failed to load profile";
        showCustomSnackBar(msg, isError: true);
      }
    } catch (e) {
      isProfileLoading.value = false;
      showCustomSnackBar("Network error. Try again.", isError: true);
    }
  }
}
