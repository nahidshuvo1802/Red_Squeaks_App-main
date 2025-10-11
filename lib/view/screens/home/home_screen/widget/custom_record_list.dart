import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_image/custom_image.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';
class CustomRecordList extends StatelessWidget {
  const CustomRecordList({super.key});

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
               Row(
                 children: [
                   Icon(Icons.play_circle,color: AppColors.red),
                   SizedBox(width: 10,),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       CustomText(text: 'Unnamed record 01', fontSize: 16.w,fontWeight: FontWeight.w600,),
                       CustomText(text: "22.05.2025 - 02:45 pm", fontSize: 8.w,fontWeight: FontWeight.w400,),
                     ],
                   ),
                 ],
               ),
               IconButton(onPressed: (){}, icon:  CustomImage(imageSrc: AppIcons.trash, height: 24.h,width: 24.w,))
              ],
            ),
          ),
          Divider(thickness: .2,color: AppColors.white_50,)
        ],
      ),
    );
  }
}
