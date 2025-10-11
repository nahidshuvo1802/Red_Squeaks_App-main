import 'package:get/get.dart';
import '../../view/screens/home/home_screen/controller/home_controller.dart';
import '../../view/screens/setting/edit_profile_setting/controller/edit_profile_controller.dart';
class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    ///==========================Default Custom Controller ==================
    Get.lazyPut(() => EditProfileController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);

  }
}
