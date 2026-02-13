import 'package:flutter/material.dart';

/// Responsive configuration with breakpoints and device detection
class ResponsiveConfig {
  // Breakpoints (in logical pixels)
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1024;

  /// Detect device type based on screen width
  static DeviceType getDeviceType(double width) {
    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Get spacing scale factor based on device type
  static double getSpacingScale(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => 1.0,
      DeviceType.tablet => 1.2,
      DeviceType.desktop => 1.4,
    };
  }

  /// Get font scale factor based on device type
  static double getFontScale(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => 1.0,
      DeviceType.tablet => 1.1,
      DeviceType.desktop => 1.2,
    };
  }

  /// Get padding based on device type (for main content)
  static EdgeInsets getContentPadding(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => const EdgeInsets.symmetric(horizontal: 16),
      DeviceType.tablet => const EdgeInsets.symmetric(horizontal: 24),
      DeviceType.desktop => const EdgeInsets.symmetric(horizontal: 40),
    };
  }

  /// Get grid column count based on device type
  static int getGridColumns(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => 2,
      DeviceType.tablet => 3,
      DeviceType.desktop => 5,
    };
  }

  /// Get dock position based on device type
  static DockPosition getDefaultDockPosition(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => DockPosition.bottom,
      DeviceType.tablet => DockPosition.left,
      DeviceType.desktop => DockPosition.left,
    };
  }
}

/// Device type enum
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Dock position enum
enum DockPosition {
  top,
  bottom,
  left,
  right,
}
