import 'package:flutter/material.dart';

/// Lista de ícones disponíveis para categorias
class CategoryIcons {
  CategoryIcons._();

  /// Ícones para despesas
  static const Map<String, IconData> expenseIcons = {
    'luz': Icons.lightbulb_outline,
    'agua': Icons.water_drop_outlined,
    'internet': Icons.wifi,
    'telefone': Icons.phone_android,
    'aluguel': Icons.home_outlined,
    'mercado': Icons.shopping_cart_outlined,
    'transporte': Icons.directions_car_outlined,
    'combustivel': Icons.local_gas_station_outlined,
    'saude': Icons.medical_services_outlined,
    'educacao': Icons.school_outlined,
    'lazer': Icons.sports_esports_outlined,
    'alimentacao': Icons.restaurant_outlined,
    'roupas': Icons.checkroom_outlined,
    'pets': Icons.pets_outlined,
    'streaming': Icons.play_circle_outline,
    'assinatura': Icons.subscriptions_outlined,
    'manutencao': Icons.build_outlined,
    'impostos': Icons.receipt_long_outlined,
    'outros': Icons.category_outlined,
  };

  /// Ícones para receitas
  static const Map<String, IconData> incomeIcons = {
    'salario': Icons.account_balance_wallet_outlined,
    'freelance': Icons.computer_outlined,
    'investimento': Icons.trending_up,
    'bonus': Icons.card_giftcard_outlined,
    'presente': Icons.redeem_outlined,
    'aluguel_recebido': Icons.house_outlined,
    'vendas': Icons.sell_outlined,
    'reembolso': Icons.replay_outlined,
    'dividendos': Icons.pie_chart_outline,
    'juros': Icons.percent,
    'renda_extra': Icons.add_circle_outline,
    'outros': Icons.category_outlined,
  };

  /// Retorna o IconData baseado no nome do ícone
  static IconData getIcon(String iconName, {bool isExpense = true}) {
    if (isExpense) {
      return expenseIcons[iconName] ?? Icons.category_outlined;
    } else {
      return incomeIcons[iconName] ?? Icons.category_outlined;
    }
  }

  /// Retorna todos os ícones disponíveis
  static Map<String, IconData> getAllIcons({bool isExpense = true}) {
    return isExpense ? expenseIcons : incomeIcons;
  }
}
