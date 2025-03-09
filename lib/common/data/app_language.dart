import 'package:shared_preferences/shared_preferences.dart';
import '../../app/widgets/authentication_widget/country_code_widget/code_country.dart';
import '../../config/assets.dart';

// class AppLanguage{
//
//   late String currentLanguage;
//   List<String> rtlLanguage = ['ar'];
//
//   bool isRtl() => rtlLanguage.contains(currentLanguage.toLowerCase());
//
//   List<CountryCode> appLanguagesData = [
//     CountryCode(
//       name: "English (US)",
//       code: "EN",
//       dialCode: '+1',
//       flagUri: '${AppAssets.flags}${"en".toLowerCase()}.png',
//     ),
//
//     CountryCode(
//       name: "Arabic",
//       code: "AR",
//       dialCode: '+966',
//       flagUri: '${AppAssets.flags}${"sa".toLowerCase()}.png',
//     ),
//   ];
//
//   Future saveLanguage(String data) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language', data);
//     await getLanguage();
//     return true;
//   }
//
//   Future getLanguage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     currentLanguage = prefs.getString('language') ?? 'en';
//     return currentLanguage;
//   }
//
// }


class AppLanguage {
  late String currentLanguage;
  List<String> rtlLanguage = ['ar'];

  // Check if the current language is RTL
  bool isRtl() => rtlLanguage.contains(currentLanguage.toLowerCase());

  // List of supported app languages
  List<CountryCode> appLanguagesData = [
    CountryCode(
      name: "English (US)",
      code: "EN",
      dialCode: '+1',
      flagUri: '${AppAssets.flags}${"en".toLowerCase()}.png',
    ),
    // CountryCode(
    //   name: "Arabic",
    //   code: "AR",
    //   dialCode: '+966',
    //   flagUri: '${AppAssets.flags}${"sa".toLowerCase()}.png',
    // ),
    CountryCode(
      name: "Spanish",
      code: "ES",
      dialCode: '+34',
      flagUri: '${AppAssets.flags}${"es".toLowerCase()}.png',
    ),
    CountryCode(
      name: "Italian",
      code: "IT",
      dialCode: '+39',
      flagUri: '${AppAssets.flags}${"it".toLowerCase()}.png',
    ),
  ];

  // Save selected language to SharedPreferences
  Future saveLanguage(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', data);
    await getLanguage();
    return true;
  }

  // Get the saved language from SharedPreferences
  Future getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLanguage = prefs.getString('language') ?? 'it';
    return currentLanguage;
  }
}
