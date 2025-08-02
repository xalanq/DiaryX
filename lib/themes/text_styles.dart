import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text styles for DiaryX application
class AppTextStyles {
  /// Private constructor to prevent instantiation
  AppTextStyles._();

  // Font sizes
  static const double _displayLarge = 32.0;
  static const double _displayMedium = 28.0;
  static const double _displaySmall = 24.0;
  static const double _headlineLarge = 22.0;
  static const double _headlineMedium = 20.0;
  static const double _headlineSmall = 18.0;

  static const double _bodyLarge = 16.0;
  static const double _bodyMedium = 14.0;
  static const double _bodySmall = 12.0;
  static const double _labelLarge = 14.0;
  static const double _labelMedium = 12.0;
  static const double _labelSmall = 10.0;

  // Font weights
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semiBold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  // Light Theme Text Styles
  static TextStyle get lightDisplayLarge => const TextStyle(
    fontSize: _displayLarge,
    fontWeight: _bold,
    color: AppColors.lightTextPrimary,
    height: 1.2,
  );

  static TextStyle get lightDisplayMedium => const TextStyle(
    fontSize: _displayMedium,
    fontWeight: _bold,
    color: AppColors.lightTextPrimary,
    height: 1.2,
  );

  static TextStyle get lightDisplaySmall => const TextStyle(
    fontSize: _displaySmall,
    fontWeight: _semiBold,
    color: AppColors.lightTextPrimary,
    height: 1.3,
  );

  static TextStyle get lightHeadlineLarge => const TextStyle(
    fontSize: _headlineLarge,
    fontWeight: _semiBold,
    color: AppColors.lightTextPrimary,
    height: 1.3,
  );

  static TextStyle get lightHeadlineMedium => const TextStyle(
    fontSize: _headlineMedium,
    fontWeight: _semiBold,
    color: AppColors.lightTextPrimary,
    height: 1.3,
  );

  static TextStyle get lightHeadlineSmall => const TextStyle(
    fontSize: _headlineSmall,
    fontWeight: _medium,
    color: AppColors.lightTextPrimary,
    height: 1.4,
  );

  static TextStyle get lightBodyLarge => const TextStyle(
    fontSize: _bodyLarge,
    fontWeight: _regular,
    color: AppColors.lightTextPrimary,
    height: 1.5,
  );

  static TextStyle get lightBodyMedium => const TextStyle(
    fontSize: _bodyMedium,
    fontWeight: _regular,
    color: AppColors.lightTextPrimary,
    height: 1.5,
  );

  static TextStyle get lightBodySmall => const TextStyle(
    fontSize: _bodySmall,
    fontWeight: _regular,
    color: AppColors.lightTextSecondary,
    height: 1.4,
  );

  static TextStyle get lightLabelLarge => const TextStyle(
    fontSize: _labelLarge,
    fontWeight: _medium,
    color: AppColors.lightTextSecondary,
    height: 1.4,
  );

  static TextStyle get lightLabelMedium => const TextStyle(
    fontSize: _labelMedium,
    fontWeight: _medium,
    color: AppColors.lightTextSecondary,
    height: 1.3,
  );

  static TextStyle get lightLabelSmall => const TextStyle(
    fontSize: _labelSmall,
    fontWeight: _medium,
    color: AppColors.lightTextSecondary,
    height: 1.3,
  );

  // Dark Theme Text Styles
  static TextStyle get darkDisplayLarge =>
      lightDisplayLarge.copyWith(color: AppColors.darkTextPrimary);

  static TextStyle get darkDisplayMedium =>
      lightDisplayMedium.copyWith(color: AppColors.darkTextPrimary);

  static TextStyle get darkDisplaySmall =>
      lightDisplaySmall.copyWith(color: AppColors.darkTextPrimary);

  static TextStyle get darkHeadlineLarge =>
      lightHeadlineLarge.copyWith(color: AppColors.darkTextPrimary);

  static TextStyle get darkHeadlineMedium =>
      lightHeadlineMedium.copyWith(color: AppColors.darkTextPrimary);

  static TextStyle get darkHeadlineSmall =>
      lightHeadlineSmall.copyWith(color: AppColors.darkTextPrimary);

  static TextStyle get darkBodyLarge =>
      lightBodyLarge.copyWith(color: AppColors.darkTextPrimary);

  static TextStyle get darkBodyMedium =>
      lightBodyMedium.copyWith(color: AppColors.darkTextPrimary);

  static TextStyle get darkBodySmall =>
      lightBodySmall.copyWith(color: AppColors.darkTextSecondary);

  static TextStyle get darkLabelLarge =>
      lightLabelLarge.copyWith(color: AppColors.darkTextSecondary);

  static TextStyle get darkLabelMedium =>
      lightLabelMedium.copyWith(color: AppColors.darkTextSecondary);

  static TextStyle get darkLabelSmall =>
      lightLabelSmall.copyWith(color: AppColors.darkTextSecondary);
}
