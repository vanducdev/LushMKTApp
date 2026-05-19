import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsController extends GetxController {
  var isDarkMode = true.obs;
  var currentLanguage = 'vi'.obs;
  var currentFont = 'Roboto'.obs;

  final List<Map<String, String>> languages = [
    {'code': 'vi', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
  ];

  final List<String> fonts = ['Roboto', 'Inter', 'Poppins', 'Open Sans'];

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('settings_dark_mode') ?? true;
    currentLanguage.value = prefs.getString('settings_language') ?? 'vi';
    currentFont.value = prefs.getString('settings_font') ?? 'Roboto';
    
    // Apply initial theme
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_dark_mode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setLanguage(String code) async {
    currentLanguage.value = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_language', code);
  }

  Future<void> setFont(String fontName) async {
    currentFont.value = fontName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_font', fontName);
  }

  // Get active TextStyle with reactive font family
  TextStyle getTextStyle({double fontSize = 14, FontWeight fontWeight = FontWeight.normal, Color? color}) {
    Color defaultColor = color ?? (isDarkMode.value ? Colors.white : Colors.black87);
    switch (currentFont.value) {
      case 'Inter':
        return GoogleFonts.inter(fontSize: fontSize, fontWeight: fontWeight, color: defaultColor);
      case 'Poppins':
        return GoogleFonts.poppins(fontSize: fontSize, fontWeight: fontWeight, color: defaultColor);
      case 'Open Sans':
        return GoogleFonts.openSans(fontSize: fontSize, fontWeight: fontWeight, color: defaultColor);
      default:
        return GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight, color: defaultColor);
    }
  }
}
