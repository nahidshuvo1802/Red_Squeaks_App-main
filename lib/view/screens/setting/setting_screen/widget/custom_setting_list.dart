import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';
class CustomSettingList extends StatelessWidget {
  final Function()? onTap;
  final IconData? icon;
  final String? title;
  final bool showArrow;
  final Color? color;
  const CustomSettingList({super.key, this.onTap, this.icon, this.title,  this.showArrow=true, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                   icon ?? Icons.person_outline_outlined,
                    color: color ??AppColors.white,
                  ),
                  CustomText(
                    left: 10.w,
                    text: title ??"text",
                    fontSize: 18.w,
                    fontWeight: FontWeight.w500,
                    color: color?? AppColors.white,
                  )
                ],
              ),
             showArrow? Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.white,
                size: 18,
              ): SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
