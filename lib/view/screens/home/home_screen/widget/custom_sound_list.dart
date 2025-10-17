import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hide_and_squeaks/view/screens/home/home_screen/controller/audio_controller.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class CustomSoundList extends StatelessWidget {
  /// 🧩 Required Data for Each Sound
  final String soundName; // e.g. "1. Let me Love your"
  final VoidCallback onPlay; // when user presses play icon
  final int index;
  final AudioController audioController;

  const CustomSoundList({
    super.key,
    required this.soundName,
    required this.onPlay,
    required this.index,
    required this.audioController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1),
      child: Column(
        children: [
          Card(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🎵 Left side: Sound name
                Expanded(
                  child: CustomText(
                    text: soundName,
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    textAlign: TextAlign.left,
                  ),
                ),
                
                // ▶️ Right side: Play/Pause button
                Obx(() {
                  final isPlaying =
                      audioController.currentPlayingIndex.value == index;
                  final isLoading =
                      audioController.isAudioLoading.value && isPlaying;

                  Widget iconWidget;

                  if (isLoading) {
                    iconWidget = const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    );
                  } else if (isPlaying && !isLoading) {
                    iconWidget = Icon(
                      Icons.pause_circle,
                      color: AppColors.red,
                      size: 30.w,
                    );
                  } else {
                    iconWidget = Icon(
                      Icons.play_circle,
                      color: AppColors.red,
                      size: 30.w,
                    );
                  }

                  return IconButton(
                    onPressed: onPlay,
                    icon: iconWidget,
                  );
                }),
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