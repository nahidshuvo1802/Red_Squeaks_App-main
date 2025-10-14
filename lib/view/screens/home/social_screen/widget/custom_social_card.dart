import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hide_and_squeaks/helper/images_handle/image_handle.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_image/custom_image.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/controller/social_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart'; // ✨ New: Import the package

SocialFeedController controller = Get.find<SocialFeedController>();

class CustomSocialCard extends StatefulWidget {
  const CustomSocialCard({
    super.key,
    required this.videoUrl,
    required this.id,
    required this.profileImage,
    required this.userName,
    required this.timeAgo,
    required this.caption,
    required this.likeCount,
    required this.dislikeCount,
    required this.shareCount,
    required this.onProfileTap,
    required this.onLikeTap,
    required this.onDislikeTap,
    required this.onShareTap,
  });

  final String videoUrl;
  final String id;
  final String profileImage;
  final String userName;
  final String timeAgo;
  final String caption;
  final int likeCount;
  final int dislikeCount;
  final int shareCount;

  final VoidCallback onProfileTap;
  final VoidCallback onLikeTap;
  final VoidCallback onDislikeTap;
  final VoidCallback onShareTap;

  @override
  State<CustomSocialCard> createState() => _CustomSocialCardState();
}

class _CustomSocialCardState extends State<CustomSocialCard> {
  VideoPlayerController? _videoController;
  bool isPlaying = false;
  bool isVideoLoading = true;
  bool _showPlayPauseIcon = false; // ✨ New: To show icon on tap

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            if (!mounted) return;
            setState(() {
              isVideoLoading = false;
            });
          });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _playVideo() {
    if (_videoController == null ||
        !_videoController!.value.isInitialized ||
        isPlaying) return;
    _videoController!.play();
    _videoController!.setLooping(true);
    if (mounted) {
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _pauseVideo() {
    if (_videoController == null ||
        !_videoController!.value.isInitialized ||
        !isPlaying) return;
    _videoController!.pause();
    if (mounted) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  void _togglePlayPause() {
    if (_videoController == null || !_videoController!.value.isInitialized)
      return;

    // 💡 Changed: Show icon briefly on tap
    setState(() {
      _showPlayPauseIcon = true;
      if (isPlaying) {
        _pauseVideo();
      } else {
        _playVideo();
      }
    });

    // Hide the icon after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showPlayPauseIcon = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✨ New: Wrap the entire card with VisibilityDetector
    return VisibilityDetector(
      key: Key(widget.id), // Unique key for each video
      onVisibilityChanged: (visibilityInfo) {
        if (!mounted || isVideoLoading) return;

        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        // 💡 Logic: If more than 70% of the video is visible, play it. Otherwise, pause it.
        if (visiblePercentage > 70) {
          _playVideo();
        } else {
          _pauseVideo();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              /// 🔹 Background Video
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.8,
                width: double.infinity,
                child: isVideoLoading
                    ? const Center(child: CircularProgressIndicator())
                    : FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),
              ),

              /// 🔹 Dark gradient overlay (bottom fade)
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                        stops: [0.0, 0.4] // Adjust gradient strength
                        ),
                  ),
                ),
              ),

              // 💡 Changed: Tap anywhere on the video to play/pause
              Positioned.fill(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _showPlayPauseIcon ? 1.0 : 0.0,
                    child: Center(
                      child: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 60,
                        color: AppColors.red.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),

              /// 🔹 Bottom info (Profile, caption, etc.)
              Positioned(
                left: 12.w,
                right: 80
                    .w, // Added to prevent text overlapping with action buttons
                bottom: 18.h,
                child: GestureDetector(
                  onTap: widget.onProfileTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.network(
                          ImageHandler.imagesHandle(widget.profileImage),
                          height: 45.h,
                          width: 45.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        // Added Expanded to handle long text
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: widget.userName,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            CustomText(
                              text: widget.caption,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔹 Right side: like, dislike, share
              Obx(() {
                final isLiked = controller.likedPosts[widget.id] ?? false;
                final isDisliked = controller.dislikedPosts[widget.id] ?? false;
                final isShared = controller.sharedPosts[widget.id] ?? false;
                final likeCount =  controller.postLikeCounts[widget.id] ?? widget.likeCount;
                final dislikeCount = controller.postDislikeCounts[widget.id] ??widget.dislikeCount;

                return Positioned(
                  right: 12.w,
                  bottom: 40.h,
                  child: Column(
                    children: [
                      _buildActionButton(
                        onTap: () => controller.likePost(widget.id),
                        iconSrc: AppIcons.like,
                        count: likeCount,
                        color: isLiked
                            ? Colors.pink.withOpacity(0.7)
                            : Colors.black.withOpacity(0.4),
                      ),
                      SizedBox(height: 12.h),
                      _buildActionButton(
                        onTap: () => controller.dislikePost(widget.id),
                        iconSrc: AppIcons.unlike,
                        count: dislikeCount,
                        color: isDisliked
                            ? Colors.pink.withOpacity(0.7)
                            : Colors.black.withOpacity(0.4),
                      ),
                      SizedBox(height: 12.h),
                      _buildActionButton(
                        onTap: () {
                           // ignore: deprecated_member_use
                          controller.shareVideo(widget.videoUrl);
                          //controller.sharePost(widget.id);
                          
                        },
                        iconSrc: AppIcons.share,
                        count: widget.shareCount,
                        color: isShared
                            ? Colors.pink.withOpacity(0.7)
                            : Colors.black.withOpacity(0.4),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String iconSrc,
    required int count,
    required Color? color,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: CustomImage(imageSrc: iconSrc, height: 24.h, width: 24.w),
          ),
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: count.toString(),
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ],
    );
  }
}
