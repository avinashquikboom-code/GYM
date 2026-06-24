import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => _getDarkTheme(AppColors.primaryGreen);
  
  static ThemeData getDarkThemeWithColor(Color accentColor) => _getDarkTheme(accentColor);

  static ThemeData _getDarkTheme(Color accentColor) {
    final isIOS = Platform.isIOS;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,
      primaryColor: accentColor,
      
      fontFamily: GoogleFonts.montserrat().fontFamily,
      
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor.withOpacity(0.7),
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),

      textTheme: GoogleFonts.montserratTextTheme(
        ThemeData.dark().textTheme.copyWith(
          titleLarge: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: AppColors.darkTextPrimary,
          ),
          titleMedium: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.darkTextPrimary,
          ),
          bodyLarge: GoogleFonts.montserrat(
            fontSize: 16,
            color: AppColors.darkTextPrimary,
          ),
          bodyMedium: GoogleFonts.montserrat(
            fontSize: 14,
            color: AppColors.darkTextSecondary,
          ),
          labelLarge: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInput,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: GoogleFonts.montserrat(
          color: AppColors.darkTextSecondary.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIconColor: AppColors.darkTextSecondary,
        suffixIconColor: AppColors.darkTextSecondary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: isIOS, // iOS centers title, Android aligns left
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: GoogleFonts.oswald(
          fontSize: isIOS ? 17 : 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }

  static ThemeData get lightTheme => _getLightTheme(AppColors.primaryGreen);
  
  static ThemeData getLightThemeWithColor(Color accentColor) => _getLightTheme(accentColor);

  static ThemeData _getLightTheme(Color accentColor) {
    final isIOS = Platform.isIOS;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightDivider,
      primaryColor: accentColor,

      fontFamily: GoogleFonts.montserrat().fontFamily,

      colorScheme: ColorScheme.light(
        primary: accentColor,
        secondary: accentColor.withOpacity(0.7),
        surface: AppColors.lightSurface,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
      ),

      textTheme: GoogleFonts.montserratTextTheme(
        ThemeData.light().textTheme.copyWith(
          titleLarge: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: AppColors.lightTextPrimary,
          ),
          titleMedium: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.lightTextPrimary,
          ),
          bodyLarge: GoogleFonts.montserrat(
            fontSize: 16,
            color: AppColors.lightTextPrimary,
          ),
          bodyMedium: GoogleFonts.montserrat(
            fontSize: 14,
            color: AppColors.lightTextSecondary,
          ),
          labelLarge: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInput,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: GoogleFonts.montserrat(
          color: AppColors.lightTextSecondary.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIconColor: AppColors.lightTextSecondary,
        suffixIconColor: AppColors.lightTextSecondary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: isIOS, // iOS centers title, Android aligns left
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: GoogleFonts.oswald(
          fontSize: isIOS ? 17 : 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }

  // Platform-specific back icon
  static IconData get platformBackIcon {
    return Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back;
  }

  // Platform-specific back button widget
  static Widget platformBackButton({VoidCallback? onPressed, Color? color}) {
    return IconButton(
      icon: Icon(platformBackIcon),
      onPressed: onPressed ?? () => Navigator.maybePop,
      color: color,
    );
  }
}
