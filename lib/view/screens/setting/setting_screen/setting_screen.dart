import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import 'package:hide_and_squeaks/view/components/custom_show_popup/custom_show_popup.dart';
import 'package:hide_and_squeaks/view/screens/authentication/controller/auth_controller.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../components/custom_text/custom_text.dart';
import 'widget/custom_setting_list.dart';

final controller = Get.put(AuthController());
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomImage(
            imageSrc: AppImages.backgroundImage,
            boxFit: BoxFit.fill,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomRoyelAppbar(
                titleName: "Setting",
              ),
              CustomNetworkImage(
                imageUrl: AppConstants.profileImage,
                height: 100.h,
                width: 100.w,
                boxShape: BoxShape.circle,
              ),
              CustomText(
                top: 10.h,
                text: "Mehedi Bin Ab. Salam",
                fontSize: 24.w,
                fontWeight: FontWeight.w600,
                bottom: 30.h,
              ),
              CustomSettingList(
                onTap: (){
                  Get.toNamed(AppRoutes.editProfileSetting);
                },
                icon: Icons.person_outline_outlined,
                title: "Edit Profile",
              ),
              CustomSettingList(
                onTap: (){
                  Get.toNamed(AppRoutes.changePasswordScreen);
                },
                icon: Icons.lock_outlined,
                title: "Change password",
              ),
              CustomSettingList(
                onTap: (){
                  Get.toNamed(AppRoutes.aboutUsScreen);
                },
                icon: Icons.info_outline_rounded,
                title: "About Us",
              ),
              CustomSettingList(
                onTap: (){
                  Get.toNamed(AppRoutes.privacyPolicyScreen);
                },
                icon: Icons.privacy_tip_outlined,
                title: "Privacy Policy",
              ),
              CustomSettingList(
                onTap: (){
                  Get.toNamed(AppRoutes.termsConditionScreen);
                },
                icon: Icons.align_vertical_bottom_outlined,
                title: "Terms and Conditions",
              ),
              CustomSettingList(
                showArrow: false,
                onTap: (){
                  showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.navbarClr,
                                insetPadding: EdgeInsets.all(8),
                                contentPadding: EdgeInsets.all(8),
                                content: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: CustomShowDialog(
                                    textColor: AppColors.white,
                                    title: "Logout Account",
                                    discription: "Are you sure you want to logout Account?",
                                    showRowButton: true,
                                    showCloseButton: true,
                                    leftOnTap: () {
                                      controller.logout();
                                      //Get.toNamed(AppRoutes.loginScreen);
                                    },
                                  ),
                                ),
                              ),
                            );
                },
                icon: Icons.logout_rounded,
                title: "Log Out",
              ),
              SizedBox(height: 30.h,),
              CustomSettingList(
                showArrow: false,
                onTap: (){},
                icon: Icons.delete,
                color: AppColors.red,
                title: "Delete Account",
              ),
            ],
          )
        ],
      ),
    );
  }
}
