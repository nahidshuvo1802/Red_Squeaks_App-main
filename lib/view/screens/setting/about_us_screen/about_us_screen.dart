import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/screens/setting/controller/misc_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';

// ignore: must_be_immutable
class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({super.key});

  final PolicyController controller = Get.put(PolicyController());

  bool _containsHtml(String text) {
    final htmlPattern =
        RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
    return htmlPattern.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final aboutText = controller.aboutUsText.toString();

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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomRoyelAppbar(titleName: "About Us"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height / 1.3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.red.withValues(alpha: .9),
                        AppColors.red2.withOpacity(0.9)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: SingleChildScrollView(
                    child: _containsHtml(aboutText)
                        ? Html(
                            data: aboutText,
                            style: {
                              "body": Style(
                                backgroundColor: Colors.transparent,
                                color: Colors.white,
                                fontSize: FontSize(14.w),
                                fontWeight: FontWeight.w400,
                                
                              ),
                              "p": Style(backgroundColor:Colors.transparent,color: Colors.white),
                              "div": Style(backgroundColor: Colors.transparent,color: Colors.white),
                              "span":
                                  Style(backgroundColor:Colors.transparent,color: Colors.white),
                                  "list" :Style(backgroundColor:Colors.transparent,color: Colors.white),
                                  "a" : Style(backgroundColor:Colors.transparent,color: Colors.white),
                                  "ol" :Style(backgroundColor:Colors.transparent,color: Colors.white),
                                  "li" :Style(backgroundColor:Colors.transparent,color: Colors.white),
                            },
                          )
                        : CustomText(
                            text: aboutText,
                            fontSize: 14.w,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
