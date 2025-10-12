import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import 'package:hide_and_squeaks/helper/shared_prefe/shared_prefe.dart';
import 'package:hide_and_squeaks/service/api_check.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/utils/app_const/app_const.dart';
import 'package:hide_and_squeaks/view/screens/home/home_screen/home_screen.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);
   TextEditingController userNameController = TextEditingController();
  TextEditingController userLocationController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();

  // =====================
  // 📸 Image pick methods
  // =====================
  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

//   // ======================
//   // 🧩 Update Profile API
//   // ======================
//  Future<void> updateProfile({
//   required String name,
//   required String phoneNumber,
//   required String location,
// }) async {
//   try {
//     final Map<String, dynamic> body = {
//       "data": {
//         "name": name,
//         "phoneNumber": phoneNumber,
//         "location": location,
//       }
//     };

//     // 🔹 Optional image file
//     final File? fileImage = selectedImage.value;

//     final response = await ApiClient.patchMultipartData(
//       ApiUrl.updateMyProfile,
//       body,
//       file: fileImage,              // ✅ image file
//       fileKey: "file",         // ✅ backend e "file" key diye receive korchho (Postman screenshot অনুযায়ী)
//     );

//     if (response.statusCode == 200) {
//       final resBody = response.body;
//       print("✅ Response: $resBody");

//       if (resBody['success'] == true) {
//         print("✅ updateProfile() finished!");
//         showCustomSnackBar("Profile updated successfully", isError: false);
//         Get.back();
//       } else {
//         showCustomSnackBar(resBody['message'] ?? "Update failed", isError: true);
//       }
//     } else {
//       ApiChecker.checkApi(response);
//     }
//   } catch (e) {
//     print("⚠️ updateProfile error: $e");
//     showCustomSnackBar("Something went wrong!", isError: true);
//   }
// }

///=========== USER UPDATE PROFILE API ===========
  RxBool userUpdateLoading = false.obs;
  Future<void> updateUserProfile() async {
    //final userId = await SharePrefsHelper.getString(AppConstants.userId);
    userUpdateLoading.value = true;
    refresh();
    Map<String, dynamic> updatedData = {
      "name": userNameController.value.text,
      "location": userLocationController.value.text,
      "phone": userPhoneController.value.text,
    };

    if (selectedImage.value != null) {
      Map<String, String> body = {
       "name": userNameController.value.text,
      "location": userLocationController.value.text,
      "phone": userPhoneController.value.text,
      };
      var response = await ApiClient.patchMultipartData(
          ApiUrl.updateProfileImage, body,
          multipartBody: [
            MultipartBody(
              'file',
              selectedImage.value!,
            )
          ]);
      if (response.statusCode == 200 || response.statusCode == 201) {
        //Get.snackbar("Success", "Profile image updated successfully.");
        Get.to(HomeScreen());
      }
    }

    var response = selectedImage.value == null
        ? await ApiClient.patchData(
            ApiUrl.updateProfile, jsonEncode(updatedData))
        : await ApiClient.patchData(
            ApiUrl.updateUserProfile, jsonEncode(updatedData));
    if (response.statusCode == 200) {
      userUpdateLoading.value = false;
      Get.snackbar("Success", "Profile updated successfully.");
      selectedImage.value = null;
    } else {
      Get.snackbar("Error", "Failed to update profile.");
      userUpdateLoading.value = false;
    }
  }

}
