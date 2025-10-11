// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import 'package:hide_and_squeaks/view/screens/home/profile_screen/profile_screen.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/social_screen.dart';
import 'package:hide_and_squeaks/view/screens/home/upload_screen/upload_screen.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
import '../home/qr_code_screen/qr_code_screen.dart';

class Navbar extends StatefulWidget {
  final int? currentIndex;

  const Navbar({this.currentIndex, super.key});

  @override
  State<Navbar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<Navbar> {
  late int bottomNavIndex;

  final List<String> selectedIcon = [
    AppIcons.qrcodeIcon,
    AppIcons.socialIcon,
    AppIcons.upload,
    AppIcons.user,
  ];
  final List<String> unselectedIcon = [
    AppIcons.qrcodeIcon,
    AppIcons.socialIcon,
    AppIcons.upload,
    AppIcons.user,
  ];

  final List<String> userNavText = [
    AppStrings.qrCode,
    AppStrings.social,
    AppStrings.upload,
    AppStrings.profile,
  ];

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80.h,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: AppColors.navbar,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.r),
              topLeft: Radius.circular(10.r),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  selectedIcon.length,
                      (index) => Row(
                    children: [
                      InkWell(
                        onTap: () => onTap(index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              bottomNavIndex == index
                                  ? selectedIcon[index]
                                  : unselectedIcon[index],
                              height: 24.h,
                              width: 24.w,
                              color: bottomNavIndex == index
                                  ? AppColors.red
                                  : AppColors.black_04,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: userNavText[index],
                              color: bottomNavIndex == index
                                  ? AppColors.red
                                  : AppColors.black_04,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.w,
                            ),
                          ],
                        ),
                      ),
                      index == 1 ? SizedBox(width: 60.w) : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -30.h,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(0), // space between border and button
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.navbar, // change border color if needed
                          width: 8.w, // thickness of the border
                        ),
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.homeScreen);
                        },
                        backgroundColor: AppColors.red,
                        shape: CircleBorder(),
                        child: CustomImage(
                          imageSrc: AppIcons.home,
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onTap(int index) {
    if (index != bottomNavIndex) {
      setState(() {
        bottomNavIndex = index;
      });
      switch (index) {
        case 0:
          Get.offAll(() => QrCodeScreen());
          break;
        case 1:
         Get.to(() => SocialScreen());
          break;
        case 2:
         Get.to(() => UploadScreen());
          break;
        case 3:
         Get.to(() => ProfileScreen());
          break;
      }
    }
  }
}