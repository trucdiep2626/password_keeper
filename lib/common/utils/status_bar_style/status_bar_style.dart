import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_keeper/presentation/theme/theme_color.dart';

import 'style_of_status_bar_content.dart';

class StatusBarStyle {
  Color setStatusBarColor() => AppColors.transparent; // Android only
  void setStatusBarStyle(StyleOfStatusBarContent styleOfStatusBarContent) {
    SystemChrome.setSystemUIOverlayStyle(styleOfStatusBarContent.androidStyle
        .copyWith(statusBarColor: setStatusBarColor(), statusBarBrightness: styleOfStatusBarContent.iosStyle));
  }
}
