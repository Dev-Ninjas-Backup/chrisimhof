import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/nav_bar/controller/nav_controller.dart';
import 'package:chrisimhof/features/tutorial/controller/tutorial_controller.dart';
import 'package:chrisimhof/features/tutorial/model/tutorial_step.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  static final GlobalKey _navStatsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.find<NavController>();
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<TutorialController>()) {
        Get.find<TutorialController>().registerKey(
          TutorialTargetId.navStatsButton,
          _navStatsKey,
        );
      }
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, bottomInset + 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.authDark,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.24),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Obx(() {
          final int activeIndex = controller.currentIndex.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(controller.items.length, (index) {
                final NavItemData item = controller.items[index];
                final navWidget = _NavItem(
                  item: item,
                  isActive: activeIndex == index,
                  onTap: () => controller.changeTab(index),
                );
                if (index == 2) {
                  return KeyedSubtree(
                    key: _navStatsKey,
                    child: navWidget,
                  );
                }
                return navWidget;
              }),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final NavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: item.label.tr,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          constraints: BoxConstraints(
            minWidth: isActive ? 72 : 44,
            maxWidth: isActive ? 135 : 44,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isActive ? 12 : 0,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryButtonColor
                : AppColors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 18,
                color: isActive ? AppColors.darkGreen : AppColors.sageMuted,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: isActive
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            item.label.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: getTextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
