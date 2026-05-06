import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorLiveScoreSection extends StatelessWidget {
  final String sectionKey;

  const CalculatorLiveScoreSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return Obx(() {
      final scores = Map<String, dynamic>.from(controller.liveScores);

      if (scores.isEmpty) {
        return const SizedBox.shrink();
      }

      final scoreBreakdown = _asMap(scores['scoreBreakdown']);
      final sections = _asMap(scores['sections']);
      final section = _asMap(sections[_apiSectionKey]);
      final sectionScore =
          _asNum(section['score']) ?? _asNum(scoreBreakdown[_scoreKey]);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryButtonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //       child: Text(
            //         'Live scores'.tr,
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w700,
            //         ),
            //       ),
            //     ),
            //     if (controller.isLiveScoresRefreshing.value)
            //       const SizedBox(
            //         width: 16,
            //         height: 16,
            //         child: CircularProgressIndicator(
            //           strokeWidth: 2,
            //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            //         ),
            //       ),
            //   ],
            // ),
            // if (scoreBreakdown.isNotEmpty) ...[
            //   const SizedBox(height: 10),
            //   Align(
            //     alignment: Alignment.centerLeft,
            //     child: _ScoreChip(
            //       label: _scoreLabel,
            //       value: scoreBreakdown[_scoreKey],
            //     ),
            //   ),
            // ],
            if (section.isNotEmpty || sectionScore != null) ...[
              const SizedBox(height: 12),
              Text(
                _sectionTitle(sectionScore),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              ..._sectionLines(section).map(
                (line) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    line,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  String get _apiSectionKey => sectionKey == 'sport' ? 'activity' : sectionKey;

  String get _scoreKey => sectionKey == 'sport' ? 'activity' : sectionKey;

  // String get _scoreLabel {
  //   switch (sectionKey) {
  //     case 'sleep':
  //       return 'Sleep'.tr;
  //     case 'nutrition':
  //       return 'Nutrition'.tr;
  //     case 'hydration':
  //       return 'Hydration'.tr;
  //     case 'caffeine':
  //       return 'Caffeine'.tr;
  //     case 'sport':
  //       return 'Activity'.tr;
  //     default:
  //       return sectionKey.tr;
  //   }
  // }

  String _sectionTitle(num? score) {
    final label = sectionKey == 'sport'
        ? 'Sport'
        : '${sectionKey.substring(0, 1).toUpperCase()}${sectionKey.substring(1)}';

    if (score == null) return label.tr;

    return '@label score: @value'.trParams({
      'label': label.tr,
      'value': _formatValue(score),
    });
  }

  List<String> _sectionLines(Map<String, dynamic> section) {
    switch (sectionKey) {
      case 'sleep':
        return [
          if (section['sleepHours'] != null)
            'Sleep hours: @value h'.trParams({
              'value': _formatValue(section['sleepHours']),
            }),
          if (section['sleepDebt'] != null)
            'Sleep debt: @value h'.trParams({
              'value': _formatValue(section['sleepDebt']),
            }),
        ];
      case 'hydration':
        return [
          if (_text(section['recommendation']).isNotEmpty)
            _text(section['recommendation']),
        ];
      case 'caffeine':
        return [
          // if (section['totalConsumedMg'] != null)
          //   'Total consumed: ${_formatValue(section['totalConsumedMg'])} mg'.tr,
          if (section['rolling8hMg'] != null)
            'Last 8 hours: @value mg'.trParams({
              'value': _formatValue(section['rolling8hMg']),
            }),
          if (section['rolling24hMg'] != null)
            'Last 24 hours: ${_formatValue(section['rolling24hMg'])} mg'.tr,
          if (section['activeMg'] != null)
            'Active Mg: ${_formatValue(section['activeMg'])} mg'.tr,
          // if (_text(section['subtitle']).isNotEmpty) _text(section['subtitle']),
        ];
      case 'sport':
        return [
          if (_text(section['recommendedIntensity']).isNotEmpty)
            'Recommended intensity: @value'.trParams({
              'value': _text(section['recommendedIntensity']),
            }),
          if (section['isRestDayRecommended'] != null)
            'Rest day recommended: @value'.trParams({
              'value': _formatBool(section['isRestDayRecommended']),
            }),
          if (_text(section['suggestedTrainingTime']).isNotEmpty)
            'Suggested training time: @value'.trParams({
              'value': _text(section['suggestedTrainingTime']),
            }),
          if (_text(section['suggestedTimeReason']).isNotEmpty)
            _text(section['suggestedTimeReason']),
          if (_text(section['durationGuidance']).isNotEmpty)
            _text(section['durationGuidance']),
          if (_text(section['subtitle']).isNotEmpty) _text(section['subtitle']),
        ];
      case 'nutrition':
        return [
          if (_text(section['subtitle']).isNotEmpty) _text(section['subtitle']),
        ];
      default:
        return const [];
    }
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static num? _asNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '');
  }

  static String _formatValue(dynamic value) {
    final number = _asNum(value);
    if (number == null) return value?.toString() ?? '-';
    if (number % 1 == 0) return number.toInt().toString();
    return number.toStringAsFixed(1);
  }

  static String _formatBool(dynamic value) {
    if (value is bool) return value ? 'Yes'.tr : 'No'.tr;
    return value?.toString() ?? '-';
  }

  static String _text(dynamic value) => value?.toString().trim() ?? '';
}

class ScoreChip extends StatelessWidget {
  final String label;
  final dynamic value;

  const ScoreChip({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x2EFFFFFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x4DFFFFFF)),
      ),
      child: Text(
        '$label: ${CalculatorLiveScoreSection._formatValue(value)}',
        style: getTextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
