import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/helper/images_handle/image_handle.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/utils/app_images/app_images.dart';
import 'package:hide_and_squeaks/view/components/custom_image/custom_image.dart';
import 'package:hide_and_squeaks/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:hide_and_squeaks/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/controller/social_controller.dart';

class SocialProfileView extends StatefulWidget {
  final String userId; // ✅ Only user ID required

  const SocialProfileView({super.key, required this.userId});

  @override
  State<SocialProfileView> createState() => _SocialProfileViewState();
}

class _SocialProfileViewState extends State<SocialProfileView> {
  final SocialFeedController controller = Get.put(SocialFeedController());

  @override
  void initState() {
    super.initState();
    controller.getUserProfile(widget.userId); // 👈 Fetch data by ID
  }

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
          Obx(() {
            if (controller.isUserProfileLoading.value) {
              // 🌀 Show loading until data comes
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final user = controller.userInfo.value;
            final videos = controller.userProfileVideos;

            if (user == null) {
              return const Center(
                child: Text(
                  "No profile data found",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomRoyelAppbar(titleName: "Profile View"),
                  // 👤 Profile Image
                  CustomNetworkImage(
                    imageUrl: ImageHandler.imagesHandle(user.photo ?? ""),
                    height: 100.h,
                    width: 100.w,
                    boxShape: BoxShape.circle,
                  ),
                  // 👤 User Name
                  CustomText(
                    top: 10.h,
                    text: user.name ?? "Unknown User",
                    fontSize: 24.w,
                    fontWeight: FontWeight.w600,
                  ),
                  // 📍 Email / Placeholder Location
                  CustomText(
                    text: "",
                    fontSize: 16.w,
                    fontWeight: FontWeight.w400,
                  ),

                  /// ======================= GridView =======================
                  GridView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 16.h),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final thumb = controller.generateThumbnail(ImageHandler.imagesHandle(video.videoUrl));
                      return GestureDetector(
                        onTap: () {
                          // TODO: open video or navigate
                        },
                        child: Stack(
                          children: [
                            // 🎬 Thumbnail
                            CustomNetworkImage(
                              imageUrl: ImageHandler.imagesHandle(thumb.toString()),
                              height: 104.h,
                              width: 86.w,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            // ❤️ Like Count
                            Positioned(
                              bottom: 4,
                              left: 10,
                              child: Row(
                                children: [
                                  CustomImage(
                                    imageSrc: AppIcons.like,
                                    height: 8.h,
                                    width: 8.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  CustomText(
                                    text: video.like.toString(),
                                    fontSize: 12.w,
                                    fontWeight: FontWeight.w400,
                                  ),
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
              ),
            );
          }),
        ],
      ),
    );
  }
}
