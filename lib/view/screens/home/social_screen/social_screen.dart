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
    /// 📡 API call once when screen loads
    controller.getSocialFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🖼 Background Image
          CustomImage(
            imageSrc: AppImages.backgroundImage,
            boxFit: BoxFit.fill,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
          ),

          /// 📲 Social Feed List
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                top: 60.h,
                text: "Social Feed",
                fontSize: 24.w,
                fontWeight: FontWeight.w600,
              ),

              /// 🔄 Loading / Data Show
              Expanded(
                child: Obx(() {
                  if (controller.isFeedLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final feeds = controller.socialFeedModel.value?.data?.socialFeeds ?? [];

                  if (feeds.isEmpty) {
                    return const Center(child: Text("😕 No feeds found"));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: feeds.length,
                    itemBuilder: (context, index) {
                      final feed = feeds[index];
                      final videoLink = "${ApiUrl.baseUrl}/${feed.videoUrl}";
                      
                      final user = feed.user;

                      return CustomSocialCard(
                        videoUrl: videoLink??"",
                        profileImage: ImageHandler.imagesHandle(user?.photo ?? ""),
                        userName: user?.name ?? "Unknown",
                        timeAgo: "3d ago", // 👈 এখানে তুমি চাইলে API field যোগ করতে পারো
                        caption: feed.title ?? "",
                        likeCount: feed.like ?? 0,
                        dislikeCount: feed.dislike ?? 0,
                        shareCount: feed.share ?? 0,
                        onProfileTap: () => Get.toNamed(AppRoutes.socialProfileView),
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
        ],
      ),
      bottomNavigationBar: const Navbar(
        currentIndex: 1,
      ),
    );
  }
}
