import 'package:flutter/material.dart';

/// Medical-themed colour palette for MedDrop.
///
/// All colours are defined as static constants so they can be referenced
/// without a [BuildContext] anywhere in the codebase.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────

  /// Primary brand colour — Medical Emerald #00A86B
  static const Color primary = Color(0xFF00A86B);

  /// Lighter tint of primary for hover / splash states
  static const Color primaryLight = Color(0xFF33C48A);

  /// Darker shade of primary for pressed states
  static const Color primaryDark = Color(0xFF007A4D);

  // ── Secondary ────────────────────────────────────────────────────────────

  /// Secondary colour — Dark Slate #1E293B
  static const Color secondary = Color(0xFF1E293B);

  /// Mid-tone variant for secondary elements
  static const Color secondaryLight = Color(0xFF334155);

  // ── Surfaces & Backgrounds ───────────────────────────────────────────────

  /// Page background — Off-White #F8FAFC
  static const Color background = Color(0xFFF8FAFC);

  /// Card / sheet surface — Pure White
  static const Color surface = Color(0xFFFFFFFF);

  /// Subtle divider / separator
  static const Color divider = Color(0xFFE2E8F0);

  // ── Semantic ─────────────────────────────────────────────────────────────

  /// Danger / Error — #EF4444
  static const Color danger = Color(0xFFEF4444);

  /// Light danger background for banners
  static const Color dangerLight = Color(0xFFFEE2E2);

  /// Warning — Amber #F59E0B
  static const Color warning = Color(0xFFF59E0B);

  /// Light warning background for banners
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Success — same as primary for medical context
  static const Color success = Color(0xFF00A86B);

  /// Light success background for banners
  static const Color successLight = Color(0xFFD1FAE5);

  // ── Text ─────────────────────────────────────────────────────────────────

  /// Primary text — near-black for maximum readability
  static const Color textPrimary = Color(0xFF0F172A);

  /// Secondary / subtitle text
  static const Color textSecondary = Color(0xFF64748B);

  /// Disabled / placeholder text
  static const Color textDisabled = Color(0xFF94A3B8);

  /// Text on dark/primary surfaces (e.g. buttons)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Miscellaneous ────────────────────────────────────────────────────────

  /// Transparent convenience constant
  static const Color transparent = Colors.transparent;

  /// Shadow colour (low opacity for elevation simulation)
  static const Color shadow = Color(0x1A000000);
}
