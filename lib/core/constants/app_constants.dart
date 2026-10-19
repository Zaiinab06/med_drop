/// App-wide constants for MedDrop.
///
/// Group constants by concern so they remain easy to find and update.
abstract final class AppConstants {
  // ── App Meta ─────────────────────────────────────────────────────────────

  static const String appName = 'MedDrop';
  static const String appVersion = '1.0.0';

  // ── API / Network ─────────────────────────────────────────────────────────

  /// Default connection timeout for Dio requests.
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Default receive timeout for Dio requests.
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Default send timeout for Dio requests (uploads).
  static const Duration sendTimeout = Duration(seconds: 60);

  /// Base URL — override via environment/flavour config at runtime.
  static const String baseUrl = 'https://your-supabase-project.supabase.co';

  // ── UI / Layout ───────────────────────────────────────────────────────────

  /// Standard horizontal page padding.
  static const double paddingHorizontal = 16.0;

  /// Standard vertical page padding.
  static const double paddingVertical = 16.0;

  /// Small padding for tight spaces.
  static const double paddingSmall = 8.0;

  /// Large padding for section separators.
  static const double paddingLarge = 24.0;

  /// Default border-radius for cards and containers.
  static const double radiusMd = 12.0;

  /// Small border-radius for chips and badges.
  static const double radiusSm = 8.0;

  /// Large border-radius for bottom sheets and modals.
  static const double radiusLg = 20.0;

  // ── Interaction ───────────────────────────────────────────────────────────

  /// Debounce duration for search fields.
  static const Duration searchDebounce = Duration(milliseconds: 400);

  /// Debounce duration for general button presses.
  static const Duration buttonDebounce = Duration(milliseconds: 300);

  /// Duration for standard page transitions.
  static const Duration pageTransition = Duration(milliseconds: 250);

  /// Duration for micro-animations (e.g. fade-ins).
  static const Duration microAnimation = Duration(milliseconds: 150);

  // ── Pagination ────────────────────────────────────────────────────────────

  /// Default number of items per paginated page.
  static const int pageSize = 20;

  // ── Storage Keys ─────────────────────────────────────────────────────────

  /// Isar database name used across the app lifecycle.
  static const String isarDbName = 'med_drop_db';

  // ── Image Compression ─────────────────────────────────────────────────────

  /// JPEG quality for prescription image uploads.
  static const int imageQuality = 80;

  /// Max width (px) for compressed prescription images.
  static const int imageMaxWidth = 1080;
}
