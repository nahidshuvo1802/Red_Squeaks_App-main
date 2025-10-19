import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';

class PolicyController extends GetxController {
  // Text controllers for the 3 text fields
  final TextEditingController aboutUsController = TextEditingController();
  final TextEditingController termsController = TextEditingController();
  final TextEditingController privacyController = TextEditingController();

  // Parsed data variables
  String aboutUsText = "";
  String termsText = "";
  String privacyText = "";

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPolicies();
  }

  // Fetch all policies from API
  Future<void> fetchAllPolicies() async {
    try {
      isLoading.value = true;

      final aboutResponse = await ApiClient.getData(ApiUrl.aboutUs);
      final termsResponse = await ApiClient.getData(ApiUrl.termsAndConditions);
      final privacyResponse = await ApiClient.getData(ApiUrl.privacyPolicy);

      if (aboutResponse.statusCode == 200 && aboutResponse.body != null) {
        aboutUsText = aboutResponse.body['data']['aboutUs'] ?? '';
        aboutUsController.text = aboutUsText;
      }

      if (termsResponse.statusCode == 200 && termsResponse.body != null) {
        termsText = termsResponse.body['data']['PrivacyPolicy'] ?? '';
        termsController.text = termsText;
      }

      if (privacyResponse.statusCode == 200 && privacyResponse.body != null) {
        privacyText = privacyResponse.body['data']['TermsConditions'] ?? '';
        privacyController.text = privacyText;
      }
    } catch (e) {
      debugPrint("Error fetching policies: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Update a specific policy
  Future<void> updatePolicy(String type) async {
    try {
      isLoading.value = true;
      String uri = "";

      if (type == "about") {
        uri = ApiUrl.aboutUs;
      } else if (type == "terms") {
        uri = ApiUrl.termsAndConditions;
      } else if (type == "privacy") {
        uri = ApiUrl.privacyPolicy;
      }

      final body = {
        "description": type == "about"
            ? aboutUsController.text
            : type == "terms"
                ? termsController.text
                : privacyController.text
      };

      final response = await ApiClient.patchData(uri, body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Policy updated successfully");
      } else {
        Get.snackbar("Error", response.statusText ?? "Update failed");
      }
    } catch (e) {
      debugPrint("Error updating policy: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
