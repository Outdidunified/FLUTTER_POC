import 'package:flutter/material.dart';

class DeviceHelper {
  static String getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return "Mobile"; // Mobile
    } else if (screenWidth < 1024) {
      return "Tablet"; // Tablet
    } else if (screenWidth < 1440) {
      return "Laptop"; // Laptop
    } else {
      return "Web"; // Web
    }
  }

  static double getFontSize(BuildContext context) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case "Mobile":
        return 16.0;
      case "Tablet":
        return 20.0;
      case "Laptop":
        return 24.0;
      case "Web":
        return 28.0;
      default:
        return 16.0;
    }
  }
}
