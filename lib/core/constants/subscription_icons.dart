import 'package:flutter/material.dart';

/// Ícones disponíveis para inscrições/assinaturas
class SubscriptionIcons {
  SubscriptionIcons._();

  static const Map<String, IconData> icons = {
    'subscriptions': Icons.subscriptions,
    'netflix': Icons.movie,
    'spotify': Icons.music_note,
    'youtube': Icons.play_circle,
    'amazon': Icons.shopping_cart,
    'disney': Icons.castle,
    'hbo': Icons.tv,
    'apple': Icons.apple,
    'google': Icons.g_mobiledata,
    'microsoft': Icons.window,
    'gym': Icons.fitness_center,
    'cloud': Icons.cloud,
    'gaming': Icons.sports_esports,
    'news': Icons.newspaper,
    'education': Icons.school,
    'software': Icons.code,
    'storage': Icons.storage,
    'vpn': Icons.vpn_key,
    'other': Icons.more_horiz,
  };

  static IconData getIcon(String key) {
    return icons[key] ?? Icons.subscriptions;
  }

  static List<String> get allKeys => icons.keys.toList();
}
