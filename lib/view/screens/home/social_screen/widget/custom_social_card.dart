import 'package:flutter/material.dart';
import 'package:hide_and_squeaks/helper/images_handle/image_handle.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_image/custom_image.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    final videoUrl = widget.videoUrl;
    
    _videoController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          isVideoLoading = false; // video loaded
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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        children: [
          /// 🔹 Video Section
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 2,
            width: MediaQuery.sizeOf(context).width,
            child: isVideoLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
          ),

          /// 🔹 Play / Pause Button
          if (!isVideoLoading)
            Positioned.fill(
              child: Center(
                child: IconButton(
                  iconSize: 50,
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
            ),

          /// 🔹 Profile & Caption Overlay
          Positioned(
            bottom: 20,
            left: 10,
            child: GestureDetector(
              onTap: widget.onProfileTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          ImageHandler.imagesHandle(widget.profileImage),
                          height: 50.h,
                          width: 50.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              text: widget.userName,
                              fontSize: 16.w,
                              fontWeight: FontWeight.w500),
                          CustomText(
                              text: widget.timeAgo,
                              fontSize: 12.w,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  CustomText(
                      text: widget.caption,
                      fontSize: 14.w,
                      fontWeight: FontWeight.w600),
                ],
              ),
            ),
          ),

          /// 🔹 Like / Dislike / Share Buttons
          Positioned(
            bottom: 60,
            right: 16,
            child: Column(
              children: [
                _buildIconButton(widget.onLikeTap, AppIcons.like, widget.likeCount),
                SizedBox(height: 10.h),
                _buildIconButton(widget.onDislikeTap, AppIcons.unlike, widget.dislikeCount),
                SizedBox(height: 10.h),
                _buildIconButton(widget.onShareTap, AppIcons.share, widget.shareCount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(VoidCallback onTap, String iconSrc, int count) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onTap,
            icon: CustomImage(imageSrc: iconSrc),
          ),
        ),
        CustomText(text: count.toString(), fontSize: 14.w, fontWeight: FontWeight.w600),
      ],
    );
  }
}