import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/nav_bar/controller/nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  void _onFabPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryTextColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavController());

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 12),
      child: SizedBox(
        height: 56,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Bridge centered behind FAB, overlapping both pill ends
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 100,
                  height: 20,
                  color: const Color(0xFF111827),
                ),
              ),
            ),

            Obx(() {
              final idx = controller.currentIndex.value;
              return Row(
                children: [
                  Expanded(
                    child: _Pill(
                      children: [
                        _NavItem(
                          icon: Icons.grid_view_rounded,
                          isActive: idx == 0,
                          onTap: () => controller.changeTab(0),
                        ),
                        _NavItem(
                          icon: Icons.show_chart_rounded,
                          isActive: idx == 1,
                          onTap: () => controller.changeTab(1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 88),
                  Expanded(
                    child: _Pill(
                      children: [
                        _NavItem(
                          icon: Icons.history_rounded,
                          isActive: idx == 2,
                          onTap: () => controller.changeTab(2),
                        ),
                        _NavItem(
                          icon: Icons.settings_rounded,
                          isActive: idx == 3,
                          onTap: () => controller.changeTab(3),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            Positioned(
              child: GestureDetector(
                onTap: () => _onFabPressed(context),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryButtonColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: AppColors.primaryButtonColor.withOpacity(0.45),
                        blurRadius: 22,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primaryTextColor,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 48,
        height: 48,
        decoration: isActive
            ? const BoxDecoration(color: Colors.white, shape: BoxShape.circle)
            : null,
        child: Icon(
          icon,
          size: 24,
          color: isActive ? AppColors.primaryButtonColor : Colors.white,
        ),
      ),
    );
  }
}

class _AddSheet extends StatelessWidget {
  const _AddSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _SheetOption(icon: Icons.note_add_rounded, label: 'New Note'),
          _SheetOption(icon: Icons.add_task_rounded, label: 'New Task'),
          _SheetOption(icon: Icons.camera_alt_rounded, label: 'Add Photo'),
          _SheetOption(icon: Icons.link_rounded, label: 'Add Link'),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF3DCA8A), size: 22),
      ),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () => Get.back(),
    );
  }
}
