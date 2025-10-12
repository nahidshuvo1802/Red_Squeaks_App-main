import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import 'package:hide_and_squeaks/helper/images_handle/image_handle.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/controller/profile_controller.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/app_icons/app_icons.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../navbar/navbar.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.getProfile(); // একবারই কল হবে
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ এখানে বারবার কল করো না, initState তে একবার কল করাই যথেষ্ট
    // profileController.getProfile();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomImage(
              imageSrc: AppImages.backgroundImage,
              boxFit: BoxFit.fill,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.cover,
            ),

            Obx(() {
              // 🔹 ইমেজ URL হ্যান্ডেল
              // 🪄 Debug print with emoji
              debugPrint("🧠 [PROFILE DEBUG]");
              debugPrint("🖼️ Profile Image URL:${profileController.profileModel.value?.data?.photo}");

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomRoyelAppbar(
                    rightIcon: AppIcons.setting,
                    titleName: "Profile View",
                    rightOnTap: () {
                      Get.toNamed(AppRoutes.settingScreen);
                    },
                  ),

                  // 🔹 Profile Picture
                  CustomNetworkImage(
                    imageUrl: ImageHandler.imagesHandle(profileController.profileModel.value?.data?.photo),
                    height: 100.h,
                    width: 100.w,
                    boxShape: BoxShape.circle,
                  ),

                  CustomText(
                    top: 15.h,
                    text: profileController.profileModel.value?.data?.name ?? "",
                    fontSize: 30.w,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),

                  CustomText(
                    text: profileController.profileModel.value?.data?.location??"",
                    fontSize: 16.w,
                    fontWeight: FontWeight.w400,
                  ),

                  SizedBox(height: 15.h),

                  ///======================= GridView Builder ====================
                  GridView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 16.h),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: [
                            CustomNetworkImage(
                              imageUrl: AppConstants.dog,
                              height: 104.h,
                              width: 86.w,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            Positioned(
                              bottom: 4,
                              left: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomImage(
                                    imageSrc: AppIcons.like,
                                    height: 8.h,
                                    width: 8.w,
                                  ),
                                  CustomText(
                                    text: "11k",
                                    fontSize: 12.w,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(width: 30.w),
                                  CustomImage(imageSrc: AppIcons.trash),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: 3),
    );
  }
}
