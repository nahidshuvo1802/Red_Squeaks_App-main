// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:hide_and_squeaks/view/screens/authentication/verify_pic_code_screen/verify_pic_code_screen_forget.dart';
import '../../view/screens/authentication/create_account_screen/create_account_screen.dart';
import '../../view/screens/authentication/forgot_password_screen/forgot_password_screen.dart';
import '../../view/screens/authentication/login_screen/login_screen.dart';
import '../../view/screens/authentication/reset_password_screen/reset_password_screen.dart';
import '../../view/screens/authentication/verify_pic_code_screen/verify_pic_code_screen.dart';
import '../../view/screens/home/home_screen/home_screen.dart';
import '../../view/screens/home/profile_screen/profile_screen.dart';
import '../../view/screens/home/qr_code_screen/qr_code_screen.dart';
import '../../view/screens/home/social_screen/social_profile_view.dart';
import '../../view/screens/home/social_screen/social_screen.dart';
import '../../view/screens/home/upload_screen/upload_screen.dart';
import '../../view/screens/navbar/navbar.dart';
import '../../view/screens/setting/about_us_screen/about_us_screen.dart';
import '../../view/screens/setting/change_password_screen/change_password_screen.dart';
import '../../view/screens/setting/edit_profile_setting/edit_profile_setting.dart';
import '../../view/screens/setting/privacy_policy_screen/privacy_policy_screen.dart';
import '../../view/screens/setting/setting_screen/setting_screen.dart';
import '../../view/screens/setting/terms_condition_screen/terms_condition_screen.dart';
import '../../view/screens/splash_screen/splash_screen.dart';
import '../../view/screens/splash_screen/splash_screen_two.dart';

class AppRoutes {
  ///===========================Splash Screen==========================
  static const String splashScreen = "/SplashScreen";
  static const String splashScreenTwo = "/SplashScreenTwo";
  static const String loginScreen = "/LoginScreen";
  static const String createAccountScreen = "/CreateAccountScreen";
  static const String verifyPicCodeScreen = "/VerifyPicCodeScreen";
  static const String verifypiccodescreenForget = '/VerifyPicCodeScreenForget';
  static const String forgotPasswordScreen = "/ForgotPasswordScreen";
  static const String resetPasswordScreen = "/ResetPasswordScreen";
  static const String navbar = "/Navbar";
  static const String homeScreen = "/HomeScreen";
  static const String qrCodeScreen = "/QrCodeScreen";
  static const String socialScreen = "/SocialScreen";
  static const String socialProfileView = "/SocialProfileView";
  static const String uploadScreen = "/UploadScreen";
  static const String profileScreen = "/ProfileScreen";
  static const String settingScreen = "/SettingScreen";
  static const String editProfileSetting = "/EditProfileSetting";
  static const String changePasswordScreen = "/ChangePasswordScreen";
  static const String aboutUsScreen = "/AboutUsScreen";
  static const String privacyPolicyScreen = "/PrivacyPolicyScreen";
  static const String termsConditionScreen = "/TermsConditionScreen";


  static List<GetPage> routes = [
///===============================Auth Routes===========================
   GetPage(name: verifypiccodescreenForget, page: () => VerifyPicCodeScreenForget()),


    ///===========================Splash Screen==========================
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: splashScreenTwo, page: () => SplashScreenTwo()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: createAccountScreen, page: () => CreateAccountScreen()),
    GetPage(name: verifyPicCodeScreen, page: () => VerifyPicCodeScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: resetPasswordScreen, page: () => ResetPasswordScreen(userId: Get.arguments)),
    GetPage(name: navbar, page: () => Navbar()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: qrCodeScreen, page: () => QrCodeScreen()),
    GetPage(name: socialScreen, page: () => SocialScreen()),
    GetPage(name: socialProfileView, page: () => SocialProfileView()),
    GetPage(name: uploadScreen, page: () => UploadScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
    GetPage(name: settingScreen, page: () => SettingScreen()),
    GetPage(name: editProfileSetting, page: () => EditProfileSetting()),
    GetPage(name: changePasswordScreen, page: () => ChangePasswordScreen()),
    GetPage(name: aboutUsScreen, page: () => AboutUsScreen()),
    GetPage(name: privacyPolicyScreen, page: () => PrivacyPolicyScreen()),
    GetPage(name: termsConditionScreen, page: () => TermsConditionScreen()),

  ];
}
