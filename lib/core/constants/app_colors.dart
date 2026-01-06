import 'package:flutter/material.dart';

/// Paleta de cores "Neofinance" do IoQoin
/// Equilibra a confiança necessária para um app financeiro
/// com a energia de uma startup de tecnologia.
class AppColors {
  AppColors._();

  // ============ Cores Primárias ============

  /// Deep FinBlue (Azul Petróleo Profundo)
  /// Função: Cor de fundo principal, textos de títulos e bases de ícones.
  /// Transmite profundidade, seriedade, inteligência e segurança.
  static const Color deepFinBlue = Color(0xFF0A2342);

  /// Volt Cyan (Ciano Elétrico)
  /// Função: Cor de destaque (accent), usada para botões de ação principal,
  /// o ícone do app e gráficos de crescimento.
  /// Transmite energia digital, clareza, futuro e dinheiro moderno.
  static const Color voltCyan = Color(0xFF00F5D4);

  // ============ Cores Secundárias (Neutras e de Apoio) ============

  /// Pure White (Branco Puro)
  /// Para textos sobre fundos escuros e limpeza visual.
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// Soft Gray (Cinza Suave)
  /// Para fundos de tela secundários, para não cansar a vista.
  static const Color softGray = Color(0xFFF4F6F8);

  /// Alert Red (Vermelho Alerta Suave)
  /// Para despesas e saldos negativos. Um vermelho menos agressivo.
  static const Color alertRed = Color(0xFFFF5A5F);

  // ============ Cores Derivadas ============

  /// Versão mais clara do Deep FinBlue para elementos secundários
  static const Color deepFinBlueLight = Color(0xFF1A3A5C);

  /// Versão escura do Volt Cyan para estados pressed/hover
  static const Color voltCyanDark = Color(0xFF00C4A8);

  /// Success Green (para receitas/ganhos positivos)
  static const Color successGreen = Color(0xFF00D68F);

  /// Texto secundário (cinza médio)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Warning Yellow (amarelo de aviso)
  static const Color warningYellow = Color(0xFFFFC107);

  /// Borda e divisores
  static const Color divider = Color(0xFFE5E7EB);
}
