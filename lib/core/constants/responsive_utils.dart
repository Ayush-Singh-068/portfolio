import 'package:flutter/material.dart';
import 'app_constants.dart';

class ResponsiveUtils {
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.tabletBreakpoint && width < AppConstants.desktopBreakpoint;
  }
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.tabletBreakpoint;
  }
  
  static double getPadding(BuildContext context) {
    if (isDesktop(context)) {
      return AppConstants.desktopPadding;
    } else if (isTablet(context)) {
      return AppConstants.tabletPadding;
    } else {
      return AppConstants.mobilePadding;
    }
  }
  
  static int getCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 1;
    }
  }
}

