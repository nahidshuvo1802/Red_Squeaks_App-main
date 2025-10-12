import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/helper/shared_prefe/shared_prefe.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/utils/app_const/app_const.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/model/profile_model.dart';

class ProfileController extends GetxController {
  /// ===============================
  /// STATES
  /// ===============================
  RxBool isProfileLoading = false.obs;
  Rx<MyProfileModel?> profileModel = Rx<MyProfileModel?>(null);


///======================GET MY PROFILE API=================================
  Future<void> getProfile() async {
  try {
    isProfileLoading.value = true;

    final response = await ApiClient.getData(ApiUrl.getMyProfile);

    if (response is Map<String, dynamic>) {
      profileModel.value = MyProfileModel.fromJson(response.body);
    } else if (response is String) {
      profileModel.value = myProfileModelFromJson(response.body);
    } else if (response.body is String) {
      profileModel.value = myProfileModelFromJson(response.body);
    } else if (response.body is Map<String, dynamic>) {
      profileModel.value = MyProfileModel.fromJson(response.body);
    } else {
      print("❌ Unknown response type: ${response.runtimeType}");
    }
  } catch (e) {
    print("Profile load error: $e");
  } finally {
    isProfileLoading.value = false;
  }
  }
}