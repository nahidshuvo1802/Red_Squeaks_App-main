import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'core/app_routes/app_routes.dart';
import 'utils/app_colors/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.microphone.request();
  await Permission.storage.request();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(393, 852),
      child: GetMaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: AppColors.black,
            appBarTheme: const AppBarTheme(

                //surfaceTintColor: AppColors.brinkPink,`
                toolbarHeight: 65,
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColors.white,
                iconTheme: IconThemeData(color: AppColors.white))),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
        initialRoute: AppRoutes.splashScreen,
        navigatorKey: Get.key,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
