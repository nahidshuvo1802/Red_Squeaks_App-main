import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/app_images/app_images.dart';

class ImageHandler {
  static String imagesHandle(String? url) {
    if (url == null || url.isEmpty) {
      return AppImages.vectorImage;
    }

    if (url.startsWith('http')) {
      return url;
    } else {
      // Ensure a slash between base URL and relative path
      String baseUrl = ApiUrl.baseUrl;
      if (!baseUrl.endsWith('/')) baseUrl += '/';
      if (url.startsWith('/')) url = url.substring(1);
      return baseUrl + url;
    }
  }
}
