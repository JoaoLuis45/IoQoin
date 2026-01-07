import 'package:flutter/material.dart';

class IconUtils {
  static const Map<int, IconData> environmentIcons = {
    58536: IconData(58536, fontFamily: 'MaterialIcons'), // person
    57534: IconData(57534, fontFamily: 'MaterialIcons'), // home
    57685: IconData(57685, fontFamily: 'MaterialIcons'), // work
    59404: IconData(59404, fontFamily: 'MaterialIcons'), // shopping_cart
    59501: IconData(59501, fontFamily: 'MaterialIcons'), // travel/flight
    57560: IconData(57560, fontFamily: 'MaterialIcons'), // savings
    59640: IconData(59640, fontFamily: 'MaterialIcons'), // restaurant
    57563: IconData(57563, fontFamily: 'MaterialIcons'), // directions_car
  };

  static IconData getEnvironmentIcon(int codePoint) {
    return environmentIcons[codePoint] ??
        const IconData(57534, fontFamily: 'MaterialIcons'); // Default to home
  }
}
