import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/nav_bar/controller/nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.put(NavController());
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, bottomInset + 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.authDark,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Obx(() {
          final int activeIndex = controller.currentIndex.value;

          return Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(controller.items.length, (index) {
                final NavItemData item = controller.items[index];
                return _NavItem(
                  item: item,
                  isActive: activeIndex == index,
                  onTap: () => controller.changeTab(index),
                );
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
          height: 38,
          constraints: BoxConstraints(
            minWidth: isActive ? 88 : 46,
            maxWidth: isActive ? 110 : 46,
          ),
          padding: EdgeInsets.symmetric(horizontal: isActive ? 12 : 0),
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryButtonColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 18,
                color: isActive
                    ? const Color(0xFF0A1410)
                    : const Color(0xFF7A8A85),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: isActive
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          item.label.tr,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF0A1410),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
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
