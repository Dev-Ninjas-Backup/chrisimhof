import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/caffeine/widgets/active_in_body_card.dart';
import 'package:chrisimhof/features/caffeine/widgets/caffeine_cut_off_card.dart';
import 'package:chrisimhof/features/caffeine/widgets/caffeine_entry_card.dart';
import 'package:chrisimhof/features/caffeine/widgets/caffeine_entry_dialog.dart';
import 'package:chrisimhof/features/caffeine/widgets/quick_add_chips_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaffeineScreen extends StatelessWidget {
  const CaffeineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CaffeineController controller = Get.put(CaffeineController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: 'Caffeine'.tr, showBackButton: true),
              const SizedBox(height: 28),

              ActiveInBodyCard(controller: controller),
              const SizedBox(height: 20),

              const CaffeineCutOffCard(),
              const SizedBox(height: 30),

              Obx(() {
                final count = controller.entriesList.length;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TODAY',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    Text(
                      '$count ${count == 1 ? 'entry' : 'entries'}',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 12),

              // Today's entries list
              Obx(() {
                if (controller.entriesList.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    alignment: Alignment.center,
                    child: Text(
                      'No caffeine entries logged today.',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSoft,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.entriesList.length,
                  itemBuilder: (context, index) {
                    final entry = controller.entriesList[index];
                    return CaffeineEntryCard(
                      entry: entry,
                      onEdit: () => showCaffeineEntryDialog(
                        context,
                        controller,
                        entry: entry,
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),

              // Quick add chips
              QuickAddChipsSection(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
