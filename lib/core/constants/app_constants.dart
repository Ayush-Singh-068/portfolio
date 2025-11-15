class AppConstants {
  static const String appName = 'Ayush Portfolio';
  static const String tagline = 'Flutter Developer | 4+ Years Experience | Mobile-first Engineer';
  
  static const double desktopBreakpoint = 1200;
  static const double tabletBreakpoint = 768;
  
  // Spacing (8pt grid)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;
  static const double spacing80 = 80.0;
  
  // Horizontal Padding
  static const double mobilePadding = 16.0;
  static const double tabletPadding = 32.0;
  static const double desktopPadding = 80.0;
  
  // Section Vertical Padding
  static const double sectionPaddingMobile = 48.0;
  static const double sectionPaddingTablet = 64.0;
  static const double sectionPaddingDesktop = 80.0;
  
  // Card Padding
  static const double cardPaddingMobile = 12.0;  // Reduced for more compact mobile cards
  static const double cardPaddingTablet = 20.0;
  static const double cardPaddingDesktop = 24.0;
  
  // Small Mobile Breakpoint
  static const double smallMobileBreakpoint = 400.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Typography
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeDisplay = 32.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);
  static const Duration animationSpring = Duration(milliseconds: 400);
  
  // Animation Delays
  static const Duration staggerDelay = Duration(milliseconds: 100);
  static const Duration textRevealDelay = Duration(milliseconds: 50);
  
  // Animation Offsets
  static const double revealOffset = 60.0;
  static const double smallRevealOffset = 30.0;
  
// Animation Curves (Note: Cannot be const, use directly in code)
// Modern easing curves for premium feel:
// - Curves.easeOutExpo (fast start, slow end)
// - Curves.easeInOutCubic (smooth both ways)
// - Curves.easeOutBack (bouncy exit)
// - Curves.easeInOutBack (bouncy both ways)
// - Curves.elasticOut (spring-like)
// - Curves.fastOutSlowIn (Material Design default)
  
  // Legacy (keeping for backward compatibility)
  static const Duration animationDuration = animationNormal;
  static const Duration scrollDuration = animationVerySlow;
}

