import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_button/custom_button.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/components/custom_text_field/custom_text_field.dart';
import 'package:hide_and_squeaks/view/screens/home/upload_screen/controller/video_controller.dart';

import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../navbar/navbar.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({super.key});

  final controller = Get.put(VideoController());
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              CustomText(
                  top: 60.h,
                  text: "Upload Video",
                  fontSize: 24.w,
                  fontWeight: FontWeight.w600),
              SizedBox(
                height: 50.h,
              ),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.pickVideoFile();
                    },
                    child: Obx(
                      () =>
                      Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: controller.isVideoPicked.value==true?Colors.green : Colors.white, width: 1)),
                        child: Obx(
                          () =>
                          Column(
                            children: [
                              CustomImage(imageSrc: AppIcons.videoIcon,imageColor: controller.isVideoPicked.value==true?Colors.green : Colors.white,),
                              CustomText(
                                top: 10,
                                text: "Drag & Drop or choose file to upload",
                                fontSize: 14.w,
                                fontWeight: FontWeight.w400,
                                bottom: 8,
                                color: controller.isVideoPicked.value==true?Colors.green : Colors.white,
                              ),
                              CustomText(
                                text: "Select Video (Max Size 350 MB)",
                                fontSize: 14.w,
                                fontWeight: FontWeight.w400,
                                color: controller.isVideoPicked.value==true?Colors.green : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      top: 20.h,
                      text: "Video Tittle",
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    maxLines: 6,
                    fillColor: Colors.transparent,
                    fieldBorderColor: AppColors.white,
                    fieldBorderRadius: 10,
                    hintText: "Enter Your Video Tittle",
                    textEditingController: titleController,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Obx( () =>
                    CustomButton(
                      onTap: () async {
                        await controller.uploadVideoWithTitle(title: titleController.value.text);
                        titleController.clear();
                      },
                      title: controller.videoUploadLoading.value==false?"Upload" : "Uploading...",
                      fontSize: 16,
                    ),
                  )
                ],
              ))
            ],
          )
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 2,
      ),
    );
  }
}
