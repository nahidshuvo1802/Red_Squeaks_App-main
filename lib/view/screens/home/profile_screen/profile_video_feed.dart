import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/view/components/custom_image/custom_image.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/controller/my_video_feed_controller.dart';
import 'package:hide_and_squeaks/view/screens/navbar/navbar.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../../helper/images_handle/image_handle.dart';

class MyVideoFeedScreen extends StatefulWidget {
  const MyVideoFeedScreen({super.key});

  @override
  State<MyVideoFeedScreen> createState() => _MyVideoFeedScreenState();
}

class _MyVideoFeedScreenState extends State<MyVideoFeedScreen> {
  final MyVideoFeedController controller = Get.put(MyVideoFeedController());

  @override
  void initState() {
    super.initState();
    controller.getMyVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🖼 Background Image
          Positioned.fill(
            child: CustomImage(
              imageSrc: AppImages.backgroundImage,
              boxFit: BoxFit.cover,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Page Title
                Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                  child: CustomText(
                    text: "My Videos",
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                // Video List
                Expanded(
                  child: Obx(() {
                    if (controller.isFeedLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final videos = controller.myVideos;

                    if (videos.isEmpty) {
                      return const Center(
                        child: Text(
                          "😕 No videos found",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => await controller.getMyVideos(),
                      color: Colors.white,
                      backgroundColor: Colors.black,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];

                          return GestureDetector(
                            onTap: () {
                              // Video play logic
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[900],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: video.thumbnail == null
                                        ? Container(
                                            height: 180.h,
                                            color: Colors.grey[850],
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : (video.thumbnail!.startsWith("http")
                                            ? Image.network(
                                                video.thumbnail!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 180.h,
                                              )
                                            : Image.file(
                                                File(video.thumbnail!),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 180.h,
                                              )),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => controller.likeVideo(video.id ?? ""),
                                              child: Icon(
                                                Icons.thumb_up,
                                                color: controller.likedPosts[video.id] == true
                                                    ? Colors.blue
                                                    : Colors.white,
                                                size: 20.sp,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            CustomText(
                                              text:
                                                  "${controller.postLikeCounts[video.id] ?? video.like ?? 0}",
                                              fontSize: 14.sp,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => controller.shareVideo(video.videoUrl ?? "", video.id ?? ""),
                                          child: Icon(
                                            Icons.share,
                                            color: Colors.white,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(currentIndex: 3),
    );
  }
}
