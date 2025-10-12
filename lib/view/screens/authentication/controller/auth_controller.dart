import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import 'package:hide_and_squeaks/helper/shared_prefe/shared_prefe.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_const/app_const.dart';
import 'package:hide_and_squeaks/view/screens/authentication/reset_password_screen/reset_password_screen.dart';
import 'package:hide_and_squeaks/view/screens/setting/setting_screen/setting_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ===========================
/// AUTH CONTROLLER (Simplified)
/// Handles: Register, Login,
/// Sign in with Google / Apple
/// ===========================/// 

  /// ---------- CONTROLLERS ---------- ///

class AuthController extends GetxController {
  /// ---------- CONTROLLERS ---------- ///
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final providerController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final otpController = TextEditingController();
  final locationController = TextEditingController();
  
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmNewPassword = TextEditingController();

  /// ---------- STATES ---------- ///
  RxBool isSignupLoading = false.obs;
  RxBool isOtpVerifying = false.obs;
  RxBool isLoginLoading = false.obs;
  RxBool isSocialSAuthLoading = false.obs;
  RxBool isForgetPasswordSendingLoading = false.obs;
  RxBool isResetPasswordLoading = false.obs;
  RxBool isSocialLoading = false.obs;
  RxBool isChangePasswordLoading = false.obs;

  String tempEmail = ""; // for OTP verification



  /// =====================================================
  /// ✅ REGISTER NEW ACCOUNT
  /// =====================================================
  Future<void> createAccount() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty || locationController.text.isEmpty) {
      showCustomSnackBar("Please fill all fields", isError: true);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showCustomSnackBar("Passwords do not match", isError: true);
      return;
    }

    isSignupLoading.value = true;
    final body = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "location" : locationController.text.trim(),
      "password": passwordController.text.trim(),
    };

    try {
      final response =
          await ApiClient.postData(ApiUrl.signUp, jsonEncode(body));
      isSignupLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        tempEmail = emailController.text.trim();

        showCustomSnackBar("OTP sent to your email!", isError: false);
        Get.offAllNamed(AppRoutes.verifyPicCodeScreen);
      } else {
        final msg = response.body['message'] ?? 'Signup failed';
        showCustomSnackBar(msg, isError: true);
      }
    } catch (e) {
      isSignupLoading.value = false;
      showCustomSnackBar("Network error. Try again.", isError: true);
    }
  }


  /// =====================================================
  /// ✅ VERIFY OTP
  /// =====================================================
  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      showCustomSnackBar("Enter OTP code", isError: true);
      return;
    }

    isOtpVerifying.value = true;

    final body = {
      "verificationCode": int.tryParse(otpController.text.trim()) ?? 0000,
    };

    try {
      final response =
          await ApiClient.patchData(ApiUrl.verifyOtp, jsonEncode(body));
      isOtpVerifying.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Account verified successfully!", isError: false);
        clearSignUpFields();
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        final msg = response.body['message'] ?? 'Invalid OTP';
        showCustomSnackBar(msg, isError: true);
      }
    } catch (e) {
      isOtpVerifying.value = false;
      showCustomSnackBar("Network error. Try again.", isError: true);
    }
  }


/// =====================================================
/// ✅ VERIFY OTP FOR FORGET PASSWORD
/// =====================================================
Future<void> verifyOtpForget() async {
  if (otpController.text.isEmpty) {
    showCustomSnackBar("Enter OTP code", isError: true);
    return;
  }

  isOtpVerifying.value = true;

  final body = {
    "verificationCode": int.tryParse(otpController.text) ?? 0000,
  };

  try {
    final response =
        await ApiClient.postData(ApiUrl.verifyOtpForget, jsonEncode(body));

    isOtpVerifying.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.body;
      final accessToken = responseBody['data'];
      final message = responseBody['message'] ?? "Account verified successfully!";

      if (accessToken != null && accessToken.isNotEmpty) {
        // ✅ Decode JWT using jwt_decoder package
        final decodedToken = JwtDecoder.decode(accessToken);
        final userId = decodedToken['id'] ?? decodedToken['_id'] ?? decodedToken['userId'];

        if (userId != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('reset_user_id', userId.toString());
        }

        showCustomSnackBar(message, isError: false);
        clearSignUpFields();
        Get.offAll(ResetPasswordScreen(userId: userId));
      } else {
        showCustomSnackBar("Access token not found", isError: true);
      }
    } else {
      final msg = response.body['message'] ?? 'Invalid OTP';
      showCustomSnackBar(msg, isError: true);
    }
  } catch (e) {
    isOtpVerifying.value = false;
    showCustomSnackBar("Network error. Try again.", isError: true);
    debugPrint("OTP Verify Error: $e");
  }
}



/// =====================================================
/// ✅ FORGOT PASSWORD (Send Email)
/// =====================================================
Future<void> forgotPassword({required String email}) async {
  if (email.isEmpty) {
    showCustomSnackBar("Please enter your email", isError: true);
    return;
  }

  isForgetPasswordSendingLoading.value = true; // এটা loading দেখানোর জন্য
  final body = {
    "email": email.trim(),
  };

  try {
    final response = await ApiClient.postData(ApiUrl.forgetPassword, jsonEncode(body));
    isForgetPasswordSendingLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.toNamed(AppRoutes.verifypiccodescreenForget);
      showCustomSnackBar("Email sent successfully! Check your inbox.", isError: false);
     
    } else {
      final msg = response.body['message'] ?? 'Failed to send email';
      showCustomSnackBar(msg, isError: true);
    }
  } catch (e) {
    isForgetPasswordSendingLoading.value = false;
    showCustomSnackBar("Network error. Try again.", isError: true);
  }
}


/// =====================================================
/// ✅ RESET PASSWORD (Send userId & new password)
/// =====================================================
/// এই মেথডটি ব্যবহারকারী যখন নতুন পাসওয়ার্ড সেট করতে চায়,
/// তখন API তে userId এবং password পাঠায়।
///
/// API Body Example:
/// {
///   "userId": "68e40b16f2aede267a2c1d47",
///   "password": "215019"
/// }
///
/// সফল হলে ইউজারকে লগইন স্ক্রিনে রিডাইরেক্ট করা হবে।
///
Future<void> resetPassword({
  required String userId,
  required String password,
}) async {
  if (userId.isEmpty || password.isEmpty) {
    showCustomSnackBar("Something Went Wrong", isError: true);
    return;
  }

  // 🔄 লোডিং শুরু (বোতামে “Sending...” দেখানোর জন্য)
  isResetPasswordLoading.value = true;

  // 🧾 Request Body তৈরি করা
  final body = {
    "userId": userId.trim(),
    "password": password.trim(),
  };

  try {
    // 🌐 API কল করা (reset password endpoint)
    final response =
        await ApiClient.postData(ApiUrl.resetPassword, jsonEncode(body));

    // 🔄 লোডিং বন্ধ করা
    isResetPasswordLoading.value = false;

    // ✅ যদি সফল হয়
    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar("Password reset successfully!", isError: false);

      // 👉 সফল হলে Login Screen-এ পাঠানো
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {
      // ❌ ব্যর্থ হলে backend এর message দেখানো
      final msg = response.body['message'] ?? 'Failed to reset password';
      showCustomSnackBar(msg, isError: true);
    }
  } catch (e) {
    // 🛑 Network বা অন্য কোনো এরর হলে
    isForgetPasswordSendingLoading.value = false;
    showCustomSnackBar("Network error. Try again.", isError: true);
  }
}

/// =====================================================
/// ✅ CHANGE PASSWORD
/// =====================================================
/// এই মেথডটি ব্যবহারকারী তার পুরনো পাসওয়ার্ড ও নতুন পাসওয়ার্ড দিয়ে
/// লগইন থাকা অবস্থায় পাসওয়ার্ড পরিবর্তন করতে পারবে।
///
/// Required Body:
/// {
///   "oldPassword": "123456",
///   "newPassword": "654321"
/// }
///
/// সফল হলে Success Snackbar দেখাবে ও user-কে আবার Login screen-এ পাঠাবে।
///
Future<void> changePassword({
  required String oldPassword,
  required String newPassword,
}) async {
  if (oldPassword.isEmpty || newPassword.isEmpty) {
    showCustomSnackBar("Please fill all fields", isError: true);
    return;
  }

  // Loading indicator toggle করতে চাইলে নতুন RxBool লাগাতে পারো
  
  isChangePasswordLoading.value = true;

  final body = {
    "newpassword": newPassword.trim().toString(),
    "oldpassword": oldPassword.trim().toString(),
  };

  try {
    final response = await ApiClient.patchData(
      ApiUrl.changePassword, // 🔹 এই endpoint টা তোমার ApiUrl এ যোগ করে নিও
      jsonEncode(body),
    );

    isChangePasswordLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar("Password changed successfully!", isError: false);
      // ✅ Password change successful হলে logout করিয়ে দেবে
      
      Get.offAllNamed(AppRoutes.settingScreen);
    } else {
      final msg = response.body['message'] ?? "Failed to change password";
      showCustomSnackBar(msg, isError: true);
    }
  } catch (e) {
    isChangePasswordLoading.value = false;
    showCustomSnackBar("Network error. Try again.", isError: true);
    debugPrint("Change Password Error: $e");
  }
}



  
  /// =====================================================
  /// ✅ LOGIN USER (Email + Password)
  /// =====================================================
  
  //==================USE THIS=====================
  /// "email":"jawog85696@aiwanlab.com",
  ///"password": "215019"
  

  Future<void> loginUser() async {
    if (loginEmailController.text.isEmpty ||
        loginPasswordController.text.isEmpty) {
      showCustomSnackBar("Please enter email & password", isError: true);
      return;
    }

    isLoginLoading.value = true;

    final body = {
      "email": loginEmailController.text.trim(),
      "password": loginPasswordController.text.trim(),
    };

    try {
      final response = await ApiClient.postData(ApiUrl.signIn, jsonEncode(body));
      isLoginLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save token if available
        if (response.body != null && response.body['data']['accessToken'] != null) {
          await SharePrefsHelper.setString(
              AppConstants.bearerToken, response.body['data']['accessToken']);
        }

       // showCustomSnackBar("Welcome back!", isError: false);
       Get.snackbar("Welcome", "Nice to see you",backgroundColor: const Color.fromARGB(96, 255, 255, 255),colorText: AppColors.red2,barBlur: 2.0);
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        final msg = /*response.body['message'] ??*/ 'Invalid email or password';
        //showCustomSnackBar(msg, isError: true);
        Get.snackbar("Failed", "Invalid Email or Password",backgroundColor: Colors.white);
      }
    } catch (e) {
      isLoginLoading.value = false;
      showCustomSnackBar("Network error. Try again.", isError: true);
    }
  }



  /// =====================================================
  /// ✅ SOCIAL AUTH (Google / Apple)
  /// =====================================================
  /// Example payload:
  /// {
  ///   "name": "Rana Alamgir",
  ///   "email": "amsohelrana.me@gmail.com",
  ///   "photo": "https://example.com/pic.png",
  ///   "provider": "googleAuth" or "appleAuth"
  /// }
  Future<void> socialAuth({
    required String name,
    required String email,
    required String photo,
    required String location,
    required String provider,
  }) async {
    isSocialSAuthLoading.value = true;

    final body = {
      "name": name,
      "email": email,
      "photo": photo,
      "location" : location,
      "provider": provider,
    };

    try {
      final response = await ApiClient.postData(ApiUrl.socialAuth, jsonEncode(body));
      isSocialSAuthLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body['data']['accessToken'] != null) {
          await SharePrefsHelper.setString(
              AppConstants.bearerToken, response.body['data']['accessToken']);
        }

        showCustomSnackBar("Signed in with $provider successfully!", isError: false);
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        final msg = response.body['message'] ?? 'Social login failed';
        showCustomSnackBar(msg, isError: true);
      }
    } catch (e) {
      isSocialLoading.value = false;
      showCustomSnackBar("Something went wrong. Try again.", isError: true);
    }

    clearSignUpFields();
  }

  /// =====================================================
  /// ✅ LOGOUT
  /// =====================================================
  Future<void> logout() async {
    await SharePrefsHelper.remove(AppConstants.bearerToken);
    Get.offAllNamed(AppRoutes.loginScreen);
    showCustomSnackBar("Logged out successfully", isError: false);
    clearSignUpFields();
  }

  /// =====================================================
  /// ✅ CLEAR FIELDS
  /// =====================================================
  void clearSignUpFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    otpController.clear();
    providerController.clear();
  }
}