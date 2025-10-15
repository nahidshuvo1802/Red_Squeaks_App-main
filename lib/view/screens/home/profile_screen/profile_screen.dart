import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import 'package:hide_and_squeaks/helper/images_handle/image_handle.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/controller/my_video_controller.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/controller/profile_controller.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/model/my_video_model.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/profile_video_feed.dart';
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
  final MyVideoController _myVideoController = Get.put(MyVideoController());

  @override
  void initState() {
    super.initState();
    profileController.getProfile();
    _myVideoController.getAllMyVideos(); // ভিডিওও লোড হবে
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ এখানে বারবার কল করো না, initState তে একবার কল করাই যথেষ্ট
    // profileController.getProfile();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Reload profile and videos
          await profileController.getProfile();
          await _myVideoController.getAllMyVideos();
        },
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // needed for RefreshIndicator
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
                final videos = _myVideoController.myVideos;
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
                    CustomNetworkImage(
                      imageUrl: ImageHandler.imagesHandle(
                          profileController.profileModel.value?.data?.photo),
                      height: 100.h,
                      width: 100.w,
                      boxShape: BoxShape.circle,
                    ),
                    CustomText(
                      top: 15.h,
                      text: profileController.profileModel.value?.data?.name ??
                          "",
                      fontSize: 30.w,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    CustomText(
                      text: profileController
                              .profileModel.value?.data?.location ??
                          "",
                      fontSize: 16.w,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 15.h),

                    // GridView of videos
                    videos.isEmpty
                        ? const Center(child: Text("No videos found"))
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: videos.length,
                            itemBuilder: (BuildContext context, int index) {
                              final video = videos[index];
                              return GestureDetector(
                                onTap: () {
                                  // Play video or open video detail
                                  Get.to(MyVideoFeedScreen());
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: video.thumbnail == null
                                          ? Container(
                                              height: 90.h,
                                              width: 80.w,
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              ),
                                            )
                                          : (video.thumbnail!.startsWith("http")
                                              ? Image.network(
                                                  video.thumbnail!,
                                                  height: 90.h,
                                                  width: 80.w,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  File(video.thumbnail!),
                                                  height: 90.h,
                                                  width: 80.w,
                                                  fit: BoxFit.cover,
                                                )),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      left: 5,
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // Like API
                                            },
                                            child: CustomImage(
                                              imageSrc: AppIcons.like,
                                              height: 10.h,
                                              width: 10.w,
                                            ),
                                          ),
                                          CustomText(
                                            text: "${video.like ?? 0}",
                                            fontSize: 12.w,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(width: 40.w),
                                          GestureDetector(
                                            onTap: () {
                                              _myVideoController
                                                  .deleteVideo(video.id!);
                                            },
                                            child: CustomImage(
                                                imageSrc: AppIcons.trash),
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
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: 3),
    );
  }
}
