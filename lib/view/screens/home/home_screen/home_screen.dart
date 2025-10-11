import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/utils/app_images/app_images.dart';
import 'package:hide_and_squeaks/view/screens/home/home_screen/controller/home_controller.dart';
import 'package:hide_and_squeaks/view/screens/navbar/navbar.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_text/custom_text.dart';
import 'widget/custom_record_list.dart';
import 'widget/custom_sound_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
               () {
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
                      Center(child: CustomImage(imageSrc: AppIcons.musiceraw)),
                      SizedBox(height: 20.h,),
                      Center(child: CustomImage(imageSrc: AppIcons.mic, height: 100,width: 100,)),
                      SizedBox(height: 10.h,),
                      Divider(thickness: .6, color: AppColors.white),
                      SizedBox(height: 20.h),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centers the icons in the Row
                          children: [
                            Expanded(child: AnimatedMusicIcon(icon: AppIcons.play, onTap: () {})),
                           // SizedBox(width: 2),
                            Expanded(child: AnimatedMusicIcon(icon: AppIcons.play2)),
                          //  SizedBox(width: 2),
                            Expanded(child: AnimatedMusicIcon(icon: AppIcons.play0)),
                          //  SizedBox(width: 2),
                            Expanded(child: AnimatedMusicIcon(icon: AppIcons.play3)),
                           // SizedBox(width: 2),
                            Expanded(child: AnimatedMusicIcon(icon: AppIcons.play4)),
                          ],
                        ),
                      ),
                      Container(
                        height: 40.h,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: AppColors.navbar2,
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(10), topRight: Radius.circular(10))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3), // Added slight padding
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              homeController.livrayTypeList.length,
                                  (index) {
                                return Expanded( // Ensures each item fits within available space
                                  child: GestureDetector(
                                    onTap: () {
                                      homeController.currentIndex.value = index; // Fixing selection logic
                                      homeController.update();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: homeController.currentIndex.value == index
                                            ? AppColors.navbar2
                                            : AppColors.navbar2, // Fixed invalid .withValues()
                                      ),
                                      child: CustomText(
                                        text: homeController.livrayTypeList[index],
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: homeController.currentIndex.value == index
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
                    if(homeController.currentIndex.value==0)
                      Column(
                        children: [
                          Container(
                            height: 300,
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              color: AppColors.navbar2,
                            ),child: Column(
                            children: List.generate(4, (value){
                              return CustomSoundList();
                            })
                          ),
                          )
                        ],
                      ),
                      if(homeController.currentIndex.value==1)
                        Container(
                          height: 300,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: AppColors.navbar2,
                          ),child: Column(
                            children: List.generate(2, (value){
                              return CustomRecordList();
                            })
                        ),
                        )
            
                    ],
                  );
                }
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Navbar(currentIndex: 5),
    );
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
      duration: const Duration(milliseconds: 150),
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