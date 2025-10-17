import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/utils/app_images/app_images.dart';
import 'package:hide_and_squeaks/view/screens/home/home_screen/controller/audio_controller.dart';
import 'package:hide_and_squeaks/view/screens/home/home_screen/controller/home_controller.dart';
import 'package:hide_and_squeaks/view/screens/navbar/navbar.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_text/custom_text.dart';
import 'widget/custom_record_list.dart';
import 'widget/custom_sound_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  final audioController = Get.put(AudioController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    debugPrint("Decibel level: ${audioController.decibelLevel.value}");
    audioController.fetchMyRecordings();

    final screenWidth = MediaQuery.of(context).size.width;
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 80),
              child: Obx(() {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CustomImage(
                        imageSrc: AppIcons.logo,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    //Center(child: CustomImage(imageSrc: AppIcons.musiceraw)),

                    SizedBox(
                      height: 20.h,
                    ),

                    Obx(() {
                      final isRec = audioController.isRecording.value;
                      final isUploading = audioController.isUploading.value;
                      final decibel = audioController.decibelLevel.value;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🔊 Animated waveform
                          if (isRec)
                            AnimatedBuilder(
                              animation: audioController.waveformController,
                              builder: (context, _) {
                                return Container(
                                  height: 80,
                                  width: double.infinity,
                                  child: CustomPaint(
                                    painter: _WaveformPainter(
                                      decibel,
                                      audioController.waveformController.value *
                                          2 *
                                          3.1416,
                                    ),
                                  ),
                                );
                              },
                            )
                          else
                            const SizedBox(height: 60),

                          const SizedBox(height: 30),

                          // 🎙 Mic button
                          GestureDetector(
                            onTap: isUploading
                                ? null
                                : () => audioController.toggleRecording(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isRec ? Colors.green : Colors.red,
                                    boxShadow: [
                                      BoxShadow(
                                        color: isRec
                                            ? Colors.greenAccent
                                                .withOpacity(0.4)
                                            : Colors.redAccent.withOpacity(0.4),
                                        blurRadius: 20,
                                        spreadRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  isRec ? Icons.stop : Icons.mic,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          if (isUploading)
                            const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                        ],
                      );
                    }),

                    Divider(thickness: .6, color: AppColors.white),
                    SizedBox(height: 20.h),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centers the icons in the Row
                        children: [
                          Expanded(
                              child: AnimatedMusicIcon(
                                  icon: AppIcons.play, onTap: () {})),
                          // SizedBox(width: 2),
                          Expanded(
                              child: AnimatedMusicIcon(icon: AppIcons.play2)),
                          //  SizedBox(width: 2),
                          Expanded(
                              child: AnimatedMusicIcon(icon: AppIcons.play0)),
                          //  SizedBox(width: 2),
                          Expanded(
                              child: AnimatedMusicIcon(icon: AppIcons.play3)),
                          // SizedBox(width: 2),
                          Expanded(
                              child: AnimatedMusicIcon(icon: AppIcons.play4)),
                        ],
                      ),
                    ),
                    Container(
                      height: 40.h,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: AppColors.navbar2,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 3), // Added slight padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            homeController.livrayTypeList.length,
                            (index) {
                              return Expanded(
                                // Ensures each item fits within available space
                                child: GestureDetector(
                                  onTap: () {
                                    homeController.currentIndex.value =
                                        index; // Fixing selection logic
                                    homeController.update();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: homeController
                                                  .currentIndex.value ==
                                              index
                                          ? AppColors.navbar2
                                          : AppColors
                                              .navbar2, // Fixed invalid .withValues()
                                    ),
                                    child: CustomText(
                                      text:
                                          homeController.livrayTypeList[index],
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          homeController.currentIndex.value ==
                                                  index
                                              ? AppColors.red
                                              : AppColors.white_50,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    if (homeController.currentIndex.value == 0)
                      Column(
                        children: [
                          Container(
                            height: 400,
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              color: AppColors.navbar2,
                            ),
                            child: Obx(() {
                          return RefreshIndicator(
                            color: AppColors.red,
                            backgroundColor: AppColors.white,
                            onRefresh: () async {
                              await audioController.fetchSoundLibrary();
                            },
                            child: Column(
                              children: [
                                // 🔁 Top refresh bar with button
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: "Sound Library",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.refresh,
                                            color: AppColors.red, size: 26),
                                        onPressed: () async {
                                          // 🌀 Manual refresh button
                                          await audioController
                                              .fetchSoundLibrary();
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // 🧭 Loader when fetching data
                                if (audioController.isFetchingSoundLibrary.value)
                                  const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.red),
                                  )
                                else if (audioController.soundLibrary.isEmpty)
                                  Expanded(
                                    child: Center(
                                      child: CustomText(
                                        text: "No Music found",
                                        fontSize: 14.sp,
                                        color: AppColors.white_50,
                                      ),
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          audioController.soundLibrary.length,
                                      itemBuilder: (context, index) {
                                        final data =audioController.soundLibrary[index];

                                        // 🕒 তারিখ ফরম্যাট
                                        final formattedDate = data.createdAt !=
                                                null
                                            ? "${data.createdAt!.day.toString().padLeft(2, '0')}.${data.createdAt!.month.toString().padLeft(2, '0')}.${data.createdAt!.year} - "
                                                "${data.createdAt!.hour.toString().padLeft(2, '0')}:${data.createdAt!.minute.toString().padLeft(2, '0')} pm"
                                            : "Unknown date";

                                        // return CustomRecordList(
                                        //   index: index,
                                        //   audioController: audioController,
                                        //   recordName: "Recording ${index + 1}",
                                        //   createdAt: formattedDate,
                                        //   onPlay: ()  async {
                                        //      await audioController.playOrPauseAudio(index, data.audioUrl);
                                        //   },
                                        //   onDelete: () async {
                                        //     await audioController
                                        //         .deleteAudioAt(index);
                                        //   },
                                        // );
                                        return CustomSoundList(
                                          soundName: " $index.  Sound $index",
                                          onPlay: () async => await audioController.playOrPauseSoundLibraryAudio(index, data.audioUrl),
                                          index: index,
                                          audioController: audioController,

                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                          )
                        ],
                      ),
                    if (homeController.currentIndex.value == 1)
                      Container(
                        height: 400,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: AppColors.navbar2,
                        ),
                        child: Obx(() {
                          return RefreshIndicator(
                            color: AppColors.red,
                            backgroundColor: AppColors.white,
                            onRefresh: () async {
                              await audioController.fetchMyRecordings();
                            },
                            child: Column(
                              children: [
                                // 🔁 Top refresh bar with button
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 1),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: "My Record Library",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.refresh,
                                            color: AppColors.red, size: 26),
                                        onPressed: () async {
                                          // 🌀 Manual refresh button
                                          await audioController
                                              .fetchMyRecordings();
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // 🧭 Loader when fetching data
                                if (audioController.isFetching.value)
                                  const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.red),
                                  )
                                else if (audioController.myRecordings.isEmpty)
                                  Expanded(
                                    child: Center(
                                      child: CustomText(
                                        text: "No recordings found 😔",
                                        fontSize: 14.sp,
                                        color: AppColors.white_50,
                                      ),
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          audioController.myRecordings.length,
                                      itemBuilder: (context, index) {
                                        final data =
                                            audioController.myRecordings[index];

                                        // 🕒 তারিখ ফরম্যাট
                                        final formattedDate = data.createdAt !=
                                                null
                                            ? "${data.createdAt!.day.toString().padLeft(2, '0')}.${data.createdAt!.month.toString().padLeft(2, '0')}.${data.createdAt!.year} - "
                                                "${data.createdAt!.hour.toString().padLeft(2, '0')}:${data.createdAt!.minute.toString().padLeft(2, '0')} pm"
                                            : "Unknown date";

                                        return CustomRecordList(
                                          index: index,
                                          audioController: audioController,
                                          recordName: "Recording ${index + 1}",
                                          createdAt: formattedDate,
                                          onPlay: ()  async {
                                             await audioController.playOrPauseAudio(index, data.audioUrl);
                                          },
                                          onDelete: () async {
                                            await audioController
                                                .deleteAudioAt(index);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                  ],
                );
              }),
            ),
          )
        ],
      ),
      bottomNavigationBar: Navbar(currentIndex: 5),
    );
  }
}

//=========================WIDGETS================================
//==========================Animated WaveForms====================================
class _WaveformPainter extends CustomPainter {
  final double decibel;
  final double time;
  _WaveformPainter(this.decibel, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.redAccent, Colors.red],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    final glowPaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final barCount = 70; // number of bars across the width
    final midY = size.height / 2;

    // normalize sound
    final normalized = (decibel.abs() / 60).clamp(0.1, 1.0);
    final amplitude = normalized * 60;

    for (int i = 0; i < barCount; i++) {
      // wave motion + some random pulse
      final wave =
          sin((i / barCount * 3.14 * 2) + (time * 0.5)) * amplitude * 0.6 +
              amplitude * Random().nextDouble() * 0.2;

      final height = wave.abs();
      final x = i * (size.width / barCount);

      // draw glowing red bars
      canvas.drawLine(
          Offset(x, midY - height), Offset(x, midY + height), glowPaint);
      canvas.drawLine(
          Offset(x, midY - height), Offset(x, midY + height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.decibel != decibel || oldDelegate.time != time;
  }
}

class AnimatedMusicIcon extends StatefulWidget {
  final String icon;
  final VoidCallback? onTap;

  const AnimatedMusicIcon({required this.icon, this.onTap, super.key});

  @override
  State<AnimatedMusicIcon> createState() => _AnimatedMusicIconState();
}

class _AnimatedMusicIconState extends State<AnimatedMusicIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: CustomImage(imageSrc: widget.icon),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
