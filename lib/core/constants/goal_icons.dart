import 'package:flutter/material.dart';

/// Ícones disponíveis para objetivos
class GoalIcons {
  GoalIcons._();

  static const Map<String, IconData> icons = {
    'savings': Icons.savings,
    'car': Icons.directions_car,
    'home': Icons.home,
    'vacation': Icons.beach_access,
    'education': Icons.school,
    'phone': Icons.phone_iphone,
    'laptop': Icons.laptop_mac,
    'emergency': Icons.health_and_safety,
    'investment': Icons.trending_up,
    'shopping': Icons.shopping_bag,
    'gift': Icons.card_giftcard,
    'wedding': Icons.favorite,
    'baby': Icons.child_care,
    'fitness': Icons.fitness_center,
    'pet': Icons.pets,
    'travel': Icons.flight,
  };

  static IconData getIcon(String key) {
    return icons[key] ?? Icons.savings;
  }

  static List<String> get allKeys => icons.keys.toList();
}
