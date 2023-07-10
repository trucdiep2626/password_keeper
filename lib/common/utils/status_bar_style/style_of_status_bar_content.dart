import 'package:flutter/services.dart';

import 'status_bar_style_type.dart';

class StyleOfStatusBarContent {
  late SystemUiOverlayStyle androidStyle;
  late Brightness iosStyle;

  StyleOfStatusBarContent(StatusBarStyleType statusBarStyle) {
    switch (statusBarStyle) {
      case StatusBarStyleType.dark:
        androidStyle = SystemUiOverlayStyle.dark;
        iosStyle = Brightness.light;
        break;
      case StatusBarStyleType.light:
        androidStyle = SystemUiOverlayStyle.light;
        iosStyle = Brightness.dark;
        break;
    }
  }
}