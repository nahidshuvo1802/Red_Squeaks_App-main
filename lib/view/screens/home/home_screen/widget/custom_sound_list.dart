import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';
class CustomSoundList extends StatelessWidget {
  const CustomSoundList({super.key});

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
                CustomText(text: '1. Let me Love your', fontSize: 14.w,fontWeight: FontWeight.w500,),
                Icon(Icons.play_circle,color: AppColors.red)
              ],
            ),
          ),
          Divider(thickness: .2,color: AppColors.white_50,)
        ],
      ),
    );
  }
}
