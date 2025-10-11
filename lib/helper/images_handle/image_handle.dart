



// ...existing code...

import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/app_images/app_images.dart';

class ImageHandler{
  static String imagesHandle(String? url) {
    if (url == null || url.isEmpty) {
      return AppImages.vectorImage;
    }
    
    if (url.startsWith('http')) {
      return url; // If the URL starts with 'http', return as is
    } else {
      return ApiUrl.imageUrl + url;
    }
  }
}