import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_image/custom_image.dart';
import 'package:hide_and_squeaks/view/screens/home/home_screen/controller/audio_controller.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class CustomRecordList extends StatelessWidget {
  /// 🧩 Required Data for Each Record
  final String recordName; // e.g. "Unnamed record 01"
  final String createdAt; // e.g. "22.05.2025 - 02:45 pm"
  final VoidCallback onPlay; // when user presses play icon
  final VoidCallback onDelete; // when user presses delete icon
  final int index;
  final AudioController audioController;

  const CustomRecordList({
    super.key,
    required this.recordName,
    required this.createdAt,
    required this.onPlay,
    required this.onDelete,
    required this.index,
    required this.audioController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
      child: Column(
        children: [
          Card(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🎵 Left side: Play button + recording info
                Row(
                  children: [
                    Obx(() {
                      final isPlaying =
                          audioController.currentPlayingIndex.value == index;
                      final isLoading =
                          audioController.isAudioLoading.value && isPlaying;

                      Widget iconWidget;

                      if (isLoading) {
                        iconWidget = const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.red,
                          ),
                        );
                      } else if (isPlaying && !isLoading) {
                        iconWidget = Icon(Icons.pause_circle,
                            color: AppColors.red, size: 30.w);
                      } else {
                        iconWidget = Icon(Icons.play_circle,
                            color: AppColors.red, size: 30.w);
                      }

                      return IconButton(
                        onPressed: onPlay,
                        icon: iconWidget,
                      );
                    }),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: recordName,
                          fontSize: 16.w,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: createdAt,
                          fontSize: 10.w,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white_50,
                        ),
                      ],
                    ),
                  ],
                ),

                // 🗑 Right side: Delete button
                IconButton(
                  onPressed: onDelete,
                  icon: CustomImage(
                    imageSrc: AppIcons.trash,
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: .2,
            color: AppColors.white_50,
          )
        ],
      ),
    );
  }
}
