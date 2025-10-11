import 'package:get/get.dart';
class HomeController extends GetxController{
  /// Service tab index
  RxInt currentIndex = 0.obs;
  RxList<String> livrayTypeList =
      ['Sound Library', 'Record Library'].obs;

}