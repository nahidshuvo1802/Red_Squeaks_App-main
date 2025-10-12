import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/view/components/custom_image/custom_image.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/controller/social_controller.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/widget/custom_social_card.dart';
import 'package:hide_and_squeaks/view/screens/navbar/navbar.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../../helper/images_handle/image_handle.dart';
import '../../../../core/app_routes/app_routes.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final SocialFeedController controller = Get.put(SocialFeedController());

  @override
  void initState() {
    super.initState();
    controller.getSocialFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🖼 Background Image
          Positioned.fill(
            child: CustomImage(
              imageSrc: AppImages.backgroundImage,
              boxFit: BoxFit.cover,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),

          /// 📲 Scrollable Feed
          SafeArea(
            child: Column(
              children: [
                /// 🔹 Page Title
                Padding(
                  padding: EdgeInsets.only(top: 20.h,bottom: 10.h),
                  child: CustomText(
                    text: "Social",
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                /// 🔹 Feed List
                Expanded(
                  child: Obx(() {
                    if (controller.isFeedLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final feeds =
                        controller.socialFeedModel.value?.data?.socialFeeds ?? [];

                    if (feeds.isEmpty) {
                      return const Center(
                        child: Text("😕 No feeds found",
                            style: TextStyle(color: Colors.white70)),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      itemCount: feeds.length,
                      itemBuilder: (context, index) {
                        final feed = feeds[index];
                        final videoLink = "${ApiUrl.baseUrl}/${feed.videoUrl}";
                        final user = feed.user;

                        return CustomSocialCard(
                          videoUrl: videoLink,
                          profileImage:
                              ImageHandler.imagesHandle(user?.photo ?? ""),
                          userName: user?.name ?? "Unknown",
                          timeAgo: "3d ago",
                          caption: feed.title ?? "",
                          likeCount: feed.like ?? 0,
                          dislikeCount: feed.dislike ?? 0,
                          shareCount: feed.share ?? 0,
                          onProfileTap: () =>
                              Get.toNamed(AppRoutes.socialProfileView),
                          onLikeTap: () => debugPrint("❤️ Liked ${feed.id}"),
                          onDislikeTap: () => debugPrint("👎 Disliked ${feed.id}"),
                          onShareTap: () => debugPrint("🔗 Shared ${feed.id}"),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),

      /// 🔹 Bottom Navigation Bar
      bottomNavigationBar: const Navbar(currentIndex: 1),
    );
  }
}
