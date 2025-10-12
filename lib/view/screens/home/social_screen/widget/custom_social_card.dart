import 'package:flutter/material.dart';
import 'package:hide_and_squeaks/helper/images_handle/image_handle.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_image/custom_image.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSocialCard extends StatefulWidget {
  const CustomSocialCard({
    super.key,
    required this.videoUrl,
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

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
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

  void _togglePlayPause() {
    if (_videoController == null) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        isPlaying = false;
      } else {
        _videoController!.play();
        _videoController!.setLooping(true);
        isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              height: MediaQuery.sizeOf(context).height / 2.2,
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
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// 🔹 Play / Pause Button
            if (!isVideoLoading)
              Positioned.fill(
                child: Center(
                  child: IconButton(
                    iconSize: 60,
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      color: AppColors.red.withOpacity(0.5),
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              ),

            /// 🔹 Bottom info (Profile, caption, etc.)
            Positioned(
              left: 12.w,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: widget.userName,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        CustomText(
                          text: widget.caption,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// 🔹 Right side: like, dislike, share
            Positioned(
              right: 12.w,
              bottom: 40.h,
              child: Column(
                children: [
                  _buildActionButton(
                    onTap: widget.onLikeTap,
                    iconSrc: AppIcons.like,
                    count: widget.likeCount,
                  ),
                  SizedBox(height: 12.h),
                  _buildActionButton(
                    onTap: widget.onDislikeTap,
                    iconSrc: AppIcons.unlike,
                    count: widget.dislikeCount,
                  ),
                  SizedBox(height: 12.h),
                  _buildActionButton(
                    onTap: widget.onShareTap,
                    iconSrc: AppIcons.share,
                    count: widget.shareCount,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String iconSrc,
    required int count,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
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
