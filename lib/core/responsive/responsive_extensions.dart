import 'package:flutter/material.dart';
import 'responsive_config.dart';

/// Extension methods for responsive design
extension ResponsiveExtension on BuildContext {
  /// Get current screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get current screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get device type based on width
  DeviceType get deviceType => ResponsiveConfig.getDeviceType(screenWidth);

  /// Check if device is mobile
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Check if device is tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if device is desktop
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Check if device is in portrait mode
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  /// Check if device is in landscape mode
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Get spacing scale factor
  double get spacingScale => ResponsiveConfig.getSpacingScale(deviceType);

  /// Get font scale factor
  double get fontScale => ResponsiveConfig.getFontScale(deviceType);

  /// Get responsive padding for content
  EdgeInsets get contentPadding =>
      ResponsiveConfig.getContentPadding(deviceType);

  /// Get grid column count
  int get gridColumns => ResponsiveConfig.getGridColumns(deviceType);

  /// Get safe area padding (accounts for notches, home indicator, etc.)
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Calculate responsive width for a given percentage
  double responsiveWidth(double percentage) {
    return screenWidth * (percentage / 100);
  }

  /// Calculate responsive height for a given percentage
  double responsiveHeight(double percentage) {
    return screenHeight * (percentage / 100);
  }

  /// Get responsive font size
  double responsiveFontSize(double baseSize) {
    return baseSize * fontScale;
  }

  /// Get responsive spacing
  double responsiveSpacing(double baseSpacing) {
    return baseSpacing * spacingScale;
  }
}

/// Extension on numbers for responsive values
extension ResponsiveNumberExtension on num {
  /// Apply spacing scale to a number
  double toResponsiveSpacing(BuildContext context) {
    return toDouble() * context.spacingScale;
  }

  /// Apply font scale to a number
  double toResponsiveFontSize(BuildContext context) {
    return toDouble() * context.fontScale;
  }
}
