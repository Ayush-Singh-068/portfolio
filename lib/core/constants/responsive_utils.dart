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
    final width = MediaQuery.of(context).size.width;
    if (width >= 1400) return 3;
    if (width >= 1200) return 3;
    if (width >= 900) return 2;
    if (width >= 600) return 2;
    if (width >= AppConstants.smallMobileBreakpoint) return 2;  // 2 columns on larger mobile
    return 1;  // 1 column on very small mobile (< 400px)
  }
  
  // Grid spacing
  static double getGridSpacing(BuildContext context) {
    if (isDesktop(context)) return AppConstants.spacing24;
    if (isTablet(context)) return AppConstants.spacing16;
    final width = MediaQuery.of(context).size.width;
    if (width >= AppConstants.smallMobileBreakpoint) return AppConstants.spacing12;
    return AppConstants.spacing8;  // Smaller spacing on very small mobile
  }
  
  // Card aspect ratios
  static double getCardAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 0.75;
    if (isTablet(context)) return 0.85;
    final width = MediaQuery.of(context).size.width;
    if (width >= AppConstants.smallMobileBreakpoint) return 1.3;  // More compact on larger mobile
    return 1.2;  // Slightly less compact on very small mobile
  }
  
  // Section padding (vertical)
  static double getSectionPadding(BuildContext context) {
    if (isDesktop(context)) return AppConstants.sectionPaddingDesktop;
    if (isTablet(context)) return AppConstants.sectionPaddingTablet;
    return AppConstants.sectionPaddingMobile;
  }
  
  // Card padding
  static double getCardPadding(BuildContext context) {
    if (isDesktop(context)) return AppConstants.cardPaddingDesktop;
    if (isTablet(context)) return AppConstants.cardPaddingTablet;
    return AppConstants.cardPaddingMobile;
  }
  
  // Check if hover is supported (web/desktop)
  static bool supportsHover(BuildContext context) {
    return !isMobile(context);
  }
}

