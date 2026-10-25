import 'dart:async';
import 'package:chrisimhof/features/nav_bar/controller/nav_controller.dart';
import 'package:chrisimhof/features/tutorial/model/tutorial_step.dart';
import 'package:chrisimhof/features/tutorial/widgets/tutorial_overlay.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialController extends GetxController {
  static const String _kTutorialCompletedKey = 'tutorial_completed_v1';

  final RxBool isActive = false.obs;
  final RxInt currentStepIndex = 1.obs;
  final Rx<Rect?> targetRect = Rx<Rect?>(null);

  final Map<TutorialTargetId, GlobalKey> targetKeys = {};
  OverlayEntry? _overlayEntry;
  Timer? _trackingTimer;

  TutorialStep? get currentStep {
    final idx = currentStepIndex.value;
    try {
      return TutorialData.steps.firstWhere((s) => s.stepIndex == idx);
    } catch (_) {
      return null;
    }
  }

  void registerKey(TutorialTargetId id, GlobalKey key) {
    targetKeys[id] = key;
    if (isActive.value && currentStep?.targetId == id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateCurrentTargetRect();
      });
    }
  }

  GlobalKey? getKey(TutorialTargetId id) => targetKeys[id];

  Future<bool> hasCompletedTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kTutorialCompletedKey) ?? false;
  }

  Future<void> markTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTutorialCompletedKey, true);
  }

  /// Automatically trigger the tutorial on first arrival if never completed
  Future<void> checkAndAutoLaunch() async {
    final completed = await hasCompletedTutorial();
    if (!completed) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!isActive.value) {
        startTour();
      }
    }
  }

  /// Start or restart the tour from Step 1
  Future<void> startTour() async {
    // Ensure we are on NavbarScreen at Tab 0
    if (Get.currentRoute != AppRoutes.navbarScreen) {
      Get.until((route) => route.settings.name == AppRoutes.navbarScreen || route.isFirst);
    }
    try {
      final navCtrl = Get.find<NavController>();
      navCtrl.changeTab(0);
    } catch (_) {}

    currentStepIndex.value = 1;
    isActive.value = true;

    _showOverlay();
    _startTracking();

    await _locateAndScrollToTarget(
      TutorialTargetId.bedtimeCard,
      alignment: 0.25,
    );
  }

  /// Advances to the next step
  Future<void> nextStep() async {
    final current = currentStepIndex.value;
    if (current >= 12) {
      endTour(completed: true);
      return;
    }

    switch (current) {
      case 1:
        // Step 1 -> Step 2 (Quick Add section)
        currentStepIndex.value = 2;
        await _locateAndScrollToTarget(
          TutorialTargetId.quickAddSection,
          alignment: 0.25,
        );
        break;

      case 2:
        // Step 2 -> Step 3 (Daily indicators gauges)
        currentStepIndex.value = 3;
        await _locateAndScrollToTarget(
          TutorialTargetId.dailyIndicators,
          alignment: 0.25,
        );
        break;

      case 3:
        // Step 3 -> Step 4 (Work card)
        currentStepIndex.value = 4;
        await _locateAndScrollToTarget(
          TutorialTargetId.workCard,
          alignment: 0.25,
        );
        break;

      case 4:
        // Step 4 -> Step 5 (Open Work Schedule -> This week card)
        Get.toNamed(AppRoutes.workScheduleScreen);
        currentStepIndex.value = 5;
        await _locateAndScrollToTarget(
          TutorialTargetId.thisWeekCard,
          alignment: 0.2,
        );
        break;

      case 5:
        // Step 5 -> Step 6 (Open Work Schedule Settings -> Rotations & templates)
        Get.toNamed(AppRoutes.workScheduleSettingsScreen);
        currentStepIndex.value = 6;
        await _locateAndScrollToTarget(
          TutorialTargetId.rotationsListCard,
          alignment: 0.15,
        );
        break;

      case 6:
        // Step 6 -> Step 7 (Show custom rotation form -> Rotation name field)
        try {
          final wssCtrl = Get.find<WorkScheduleSettingsController>();
          wssCtrl.isCreatingNewRotation.value = true;
        } catch (_) {}
        currentStepIndex.value = 7;
        await _locateAndScrollToTarget(
          TutorialTargetId.rotationNameField,
          alignment: 0.15,
        );
        break;

      case 7:
        // Step 7 -> Step 8 (Return to Home without saving -> Sleep & naps card)
        Get.until((route) => route.settings.name == AppRoutes.navbarScreen || route.isFirst);
        try {
          final navCtrl = Get.find<NavController>();
          navCtrl.changeTab(0);
        } catch (_) {}
        currentStepIndex.value = 8;
        await _locateAndScrollToTarget(
          TutorialTargetId.lastSleepCard,
          alignment: 0.3,
        );
        break;

      case 8:
        // Step 8 -> Step 9 (Home -> Recommendations preview)
        currentStepIndex.value = 9;
        await _locateAndScrollToTarget(
          TutorialTargetId.forYouSection,
          alignment: 0.25,
        );
        break;

      case 9:
        // Step 9 -> Step 10 (Home -> Stats icon in bottom bar)
        currentStepIndex.value = 10;
        await _locateAndScrollToTarget(
          TutorialTargetId.navStatsButton,
          alignment: 0.9,
        );
        break;

      case 10:
        // Step 10 -> Step 11 (Open Stats tab -> 2 views selector)
        try {
          final navCtrl = Get.find<NavController>();
          navCtrl.changeTab(2);
        } catch (_) {}
        currentStepIndex.value = 11;
        await _locateAndScrollToTarget(
          TutorialTargetId.historyTabs,
          alignment: 0.05,
        );
        break;

      case 11:
        // Step 11 -> Step 12 (Open Profile tab -> Basic profile card)
        try {
          final navCtrl = Get.find<NavController>();
          navCtrl.changeTab(3);
        } catch (_) {}
        currentStepIndex.value = 12;
        await _locateAndScrollToTarget(
          TutorialTargetId.basicProfileCard,
          alignment: 0.08, // Keep near the top so it stays well clear of bottom nav bar
        );
        break;
    }
  }

  /// Skip tour immediately at any step
  Future<void> skipTour() async {
    endTour(completed: false);
  }

  /// End tour, dismiss overlay and persist completion
  Future<void> endTour({bool completed = true}) async {
    isActive.value = false;
    targetRect.value = null;
    _stopTracking();
    try {
      _overlayEntry?.remove();
    } catch (_) {}
    _overlayEntry = null;
    await markTutorialCompleted();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    OverlayState? overlayState;
    if (Get.overlayContext != null) {
      try {
        overlayState = Overlay.of(Get.overlayContext!);
      } catch (_) {}
    }
    overlayState ??= Get.key.currentState?.overlay;
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => const TutorialOverlay(),
    );
    overlayState.insert(_overlayEntry!);
  }

  void _startTracking() {
    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!isActive.value) {
        _stopTracking();
        return;
      }
      _updateCurrentTargetRect();
    });
  }

  void _stopTracking() {
    _trackingTimer?.cancel();
    _trackingTimer = null;
  }

  Future<void> _locateAndScrollToTarget(
    TutorialTargetId targetId, {
    double alignment = 0.2,
    int maxAttempts = 35, // 35 * 100ms = up to 3.5s retry
  }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final key = targetKeys[targetId];
      if (key?.currentContext != null) {
        final renderBox = key!.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize && renderBox.size.height > 10) {
          try {
            await Scrollable.ensureVisible(
              key.currentContext!,
              duration: const Duration(milliseconds: 300),
              alignment: alignment,
              curve: Curves.easeInOut,
            );
          } catch (_) {}
          await Future.delayed(const Duration(milliseconds: 150));
          _updateCurrentTargetRect();
          return;
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    _updateCurrentTargetRect();
  }

  void _updateCurrentTargetRect() {
    final step = currentStep;
    if (step == null) {
      if (targetRect.value != null) targetRect.value = null;
      return;
    }

    final key = targetKeys[step.targetId];
    if (key == null || key.currentContext == null) {
      if (targetRect.value != null) targetRect.value = null;
      return;
    }

    try {
      final renderBox = key.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize && renderBox.size.height > 5) {
        final offset = renderBox.localToGlobal(Offset.zero);
        final newRect = offset & renderBox.size;
        if (targetRect.value != newRect) {
          targetRect.value = newRect;
        }
      } else {
        if (targetRect.value != null) targetRect.value = null;
      }
    } catch (_) {
      if (targetRect.value != null) targetRect.value = null;
    }
  }

  @override
  void onClose() {
    _stopTracking();
    try {
      _overlayEntry?.remove();
    } catch (_) {}
    _overlayEntry = null;
    super.onClose();
  }
}
