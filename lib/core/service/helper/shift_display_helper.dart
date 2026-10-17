import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/service/helper/custom_rotation_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Helper to handle shift initials, localized display codes, and colors.
///
/// Features:
/// 1. Automatic language adaptation:
///    - French: Day -> 'J' (Jour), Evening -> 'A' (Après-midi), Night -> 'N' (Nuit), Off -> 'Repos'
///    - English: Day -> 'D', Evening -> 'E', Night -> 'N', Off -> 'Off'
/// 2. User-defined custom initials per shift type (e.g. customized 'J' or 'D')
/// 3. Per-day custom code overrides (e.g. 'DN' for a Monday night shift)
/// 4. Dynamic uppercase initial for user-named shifts (e.g. 'Matin' -> 'M')
class ShiftDisplayHelper {
  static final RxMap<String, String> customShiftInitials = <String, String>{}.obs;
  static final RxMap<String, String> customDayCodes = <String, String>{}.obs;

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      final initials = await CustomRotationPrefs.getCustomShiftInitials();
      customShiftInitials.assignAll(initials);
      final dayCodes = await CustomRotationPrefs.getDayDisplayCodes();
      customDayCodes.assignAll(dayCodes);
      _initialized = true;
    } catch (e) {
      debugPrint('ShiftDisplayHelper init error: $e');
    }
  }

  static Future<void> setCustomShiftInitial(String shiftKey, String? initial) async {
    final lowerKey = canonicalShiftKey(shiftKey);
    if (initial == null || initial.trim().isEmpty) {
      customShiftInitials.remove(lowerKey);
    } else {
      customShiftInitials[lowerKey] = initial.trim().toUpperCase();
    }
    await CustomRotationPrefs.setCustomShiftInitials(customShiftInitials);
  }

  static Future<void> setCustomDayCode(String key, String? code) async {
    if (code == null || code.trim().isEmpty) {
      customDayCodes.remove(key);
    } else {
      customDayCodes[key] = code.trim().toUpperCase();
    }
    await CustomRotationPrefs.setDayDisplayCodes(customDayCodes);
  }

  /// Strictly maps any shift name, localized initial/word, or custom code
  /// into canonical API wire format: 'day', 'evening', 'night', 'off'.
  /// For user-created custom shift types (e.g. 'Swing'), sanitizes to snake_case.
  static String toCanonicalApiKey(String shift) {
    final lower = shift.trim().toLowerCase();
    if (lower.isEmpty) return 'off';

    // 1. Direct canonical & French matches
    if (lower == 'day' || lower == 'd' || lower == 'jour' || lower == 'j') return 'day';
    if (lower == 'evening' ||
        lower == 'e' ||
        lower == 'après-midi' ||
        lower == 'apres-midi' ||
        lower == 'a' ||
        lower == 'afternoon') {
      return 'evening';
    }
    if (lower == 'night' || lower == 'n' || lower == 'nuit') return 'night';
    if (lower == 'off' || lower == 'repos' || lower == 'r') return 'off';

    // 2. Reverse lookup against user-defined custom initials
    for (final entry in customShiftInitials.entries) {
      if (entry.value.trim().toLowerCase() == lower) {
        return entry.key;
      }
    }

    // 3. Composite override code (e.g. 'DN' -> 'night')
    if (lower == 'dn') return 'night';

    // 4. Fallback for custom shift keys (e.g. 'Matin' -> 'matin')
    return lower.replaceAll(RegExp(r'[\s\-]+'), '_').replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  /// Strictly maps any shift name, localized initial, or custom code
  /// into canonical 1-letter / short API pattern code: 'D', 'E', 'N', 'Off'.
  /// Crucial: 'E' is ALWAYS sent for evening shifts, NEVER French 'A'.
  static String toCanonicalPatternCode(String shift) {
    final apiKey = toCanonicalApiKey(shift);
    if (apiKey == 'day') return 'D';
    if (apiKey == 'evening') return 'E';
    if (apiKey == 'night') return 'N';
    final lower = shift.trim().toLowerCase();
    if (lower.contains('matin') || lower.contains('morning')) return 'D';
    if (lower.contains('soir')) return 'E';
    return 'Off';
  }

  static String canonicalShiftKey(String shift) {
    return toCanonicalApiKey(shift);
  }

  /// Returns the localized display code / initial for a shift.
  /// Priority:
  /// 1. Explicit per-day override code (if passed or in customDayCodes)
  /// 2. User-customized initial for this shift type
  /// 3. Automatic language-based default:
  ///    - French: Day -> 'J', Evening -> 'A', Night -> 'N', Off -> 'Repos'
  ///    - English: Day -> 'D', Evening -> 'E', Night -> 'N', Off -> 'Off'
  ///    - Custom shift name: first uppercase character (e.g. 'Matin' -> 'M')
  static String getDisplayCode(
    String shift, {
    String? dayKey,
    String? customOverride,
    bool? isFrench,
  }) {
    // 1. Explicit override passed or found in customDayCodes
    if (customOverride != null && customOverride.trim().isNotEmpty) {
      return customOverride.trim();
    }
    if (dayKey != null && customDayCodes.containsKey(dayKey)) {
      final code = customDayCodes[dayKey];
      if (code != null && code.trim().isNotEmpty) {
        return code.trim();
      }
    }

    final trimmed = shift.trim();
    final fr = isFrench ?? ((Get.locale?.languageCode ?? 'en') == 'fr');

    if (trimmed.isEmpty) {
      return fr ? 'Repos' : 'Off';
    }

    final lower = trimmed.toLowerCase();

    // Check if the input is an explicit short override code (like 'DN', 'N1', etc.)
    final isExplicitOverrideCode = (trimmed == trimmed.toUpperCase() &&
            trimmed.length <= 4 &&
            trimmed.length >= 2) ||
        (trimmed.length == 2 && !trimmed.contains(' '));
    if (isExplicitOverrideCode &&
        lower != 'day' &&
        lower != 'jour' &&
        lower != 'off' &&
        lower != 'repos') {
      return trimmed.toUpperCase();
    }

    // 2. User-customized initial for this shift type
    final canonical = canonicalShiftKey(trimmed);
    if (customShiftInitials.containsKey(canonical)) {
      final customInit = customShiftInitials[canonical];
      if (customInit != null && customInit.trim().isNotEmpty) {
        return customInit.trim();
      }
    }

    // 3. Automatic language-based default
    if (canonical == 'day') {
      return fr ? 'J' : 'D';
    }
    if (canonical == 'evening') {
      return fr ? 'A' : 'E';
    }
    if (canonical == 'night') {
      return 'N';
    }
    if (canonical == 'off') {
      return fr ? 'Repos' : 'Off';
    }

    // For any user-defined shift name (e.g. "Matin"), derive first letter uppercase
    return trimmed[0].toUpperCase();
  }

  /// Canonical category: 'day', 'evening', 'night', 'off', or 'custom'
  static String getShiftCategory(String shift) {
    final canonical = toCanonicalApiKey(shift);
    if (canonical == 'day' ||
        canonical == 'evening' ||
        canonical == 'night' ||
        canonical == 'off') {
      return canonical;
    }
    return 'custom';
  }

  static Color getBackgroundColor(String shift) {
    final cat = getShiftCategory(shift);
    switch (cat) {
      case 'day':
        return AppColors.amberSoft3;
      case 'evening':
        return AppColors.lavenderSoft;
      case 'night':
        return AppColors.indigoSoft;
      case 'off':
        return AppColors.mintSoft2;
      default:
        return AppColors.mintSoft3;
    }
  }

  static Color getTextColor(String shift) {
    final cat = getShiftCategory(shift);
    switch (cat) {
      case 'day':
        return AppColors.orangeAccent2;
      case 'evening':
        return AppColors.violet;
      case 'night':
        return AppColors.indigo;
      case 'off':
        return AppColors.secondaryButtonColor;
      default:
        return AppColors.secondaryButtonColor;
    }
  }
}
