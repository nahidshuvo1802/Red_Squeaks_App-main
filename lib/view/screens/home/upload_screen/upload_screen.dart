import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_button/custom_button.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/components/custom_text_field/custom_text_field.dart';
import 'package:hide_and_squeaks/view/screens/home/upload_screen/controller/video_controller.dart';

import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../navbar/navbar.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({super.key});

  final controller = Get.put(VideoController());
  final TextEditingController titleController = TextEditingController();

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
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 50.h),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.pickVideoFile();
                      },
                      child: Obx(() {
                        final file = controller.selectedVideo.value;
                        if (file != null &&
                            controller.chewieController != null) {
                          // 🎬 Show video preview
                          return Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Chewie(
                                  controller: controller.chewieController!),
                            ),
                          );
                        } else {
                          // 🧩 Show default picker box
                          return Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.video_library_rounded,
                                    color: Colors.white, size: 50),
                                SizedBox(height: 10.h),
                                CustomText(
                                  text: "Drag & Drop or choose file to upload",
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                CustomText(
                                  text: "Select Video (Max Size 350 MB)",
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        top: 20.h,
                        text: "Video Title",
                        fontSize: 16.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      maxLines: 6,
                      fillColor: Colors.transparent,
                      fieldBorderColor: AppColors.white,
                      fieldBorderRadius: 10,
                      hintText: "Enter Your Video Title",
                      textEditingController: titleController,
                    ),
                    SizedBox(height: 50.h),
                    Obx(
                      () => CustomButton(
                        onTap: () async {
                          await controller.uploadVideoWithTitle(
                            title: titleController.value.text,
                          );
                          titleController.clear();
                        },
                        title: controller.videoUploadLoading.value == false
                            ? "Upload"
                            : "Uploading...",
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Navbar(currentIndex: 2),
    );
  }
}
