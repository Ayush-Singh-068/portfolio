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
  
  // Scroll Detection Constants
  static const double scrollThrottleMs = 100.0; // Throttle scroll events to 100ms
  static const double activeSectionThreshold = 0.3; // 30% of screen height
  static const double activeSectionTopOffset = -100.0; // Top offset for section detection
  static const double scrollProgressMax = 200.0; // Max scroll for progress calculation
  static const double navbarBlurMin = 15.0; // Minimum blur intensity
  static const double navbarBlurMax = 30.0; // Maximum blur intensity
  static const double navbarHeight = 72.0; // Navbar height
  static const double navbarHideOffset = -80.0; // Navbar hide offset
  
  // Scroll Reveal Constants
  static const Duration scrollRevealCheckInterval = Duration(milliseconds: 200);
  static const Duration scrollRevealInitialDelay = Duration(milliseconds: 300);
  static const double scrollRevealViewportMultiplier = 1.5; // Viewport multiplier for visibility check
  
  // Profile Image Constants
  static const double profileImageSizeDesktop = 220.0;
  static const double profileImageSizeTablet = 200.0;
  static const double profileImageSizeMobile = 180.0;
  static const double profileImageParallaxFactor = 0.5;
  static const double profileImageFloatOffset = 8.0;
  
  // Contact Constants
  static const String contactEmail = 'ayushrajavat2018@gmail.com';
  static const String contactLocation = 'Kanpur, India';
  static const String linkedInUrl = 'https://www.linkedin.com/in/ayush-singh-3a0ab2165/';
  static const String githubUrl = 'https://github.com';
  
  // Project Constants
  static const int projectDescriptionMaxLength = 250;
  static const int projectDescriptionPreviewLength = 200;
  
  // Animation Controller Durations
  static const Duration backgroundGradientDuration = Duration(seconds: 10);
  static const Duration backgroundParticleDuration = Duration(seconds: 20);
  static const Duration profilePulseDuration = Duration(seconds: 3);
  static const Duration profileRotateDuration = Duration(seconds: 20);
  static const Duration profileFloatDuration = Duration(seconds: 4);
  static const Duration timelinePulseDuration = Duration(seconds: 2);
  static const Duration timelineGlowDuration = Duration(milliseconds: 1500);
}

