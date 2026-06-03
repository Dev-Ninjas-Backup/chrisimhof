import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/controller/delete_account_controller.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/widgets/delete_account_warning.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/widgets/delete_checkbox_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});
  final DeleteAccountController controller = Get.put(DeleteAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: 'Delete account'.tr,
                  showBackButton: true,
                  showMoreButton: true,
                ),
                const SizedBox(height: 28),
                Text(
                  'Delete account'.tr,
                  style: getTextStyle2(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This action removes your personal RYVENZA profile and app data after confirmation.'
                      .tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMid,
                  ),
                ),
                const SizedBox(height: 30),
                DeleteAccountWarning(),
                const SizedBox(height: 16),
                Obx(
                  () => DeleteCheckboxItem(
                    text: 'I understand this cannot be undone.'.tr,
                    value: controller.understandCannotBeUndone.value,
                    onChanged: (v) => controller.toggleUnderstand(v),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => DeleteCheckboxItem(
                    text: 'I want to remove my personal profile.'.tr,
                    value: controller.removePersonalProfile.value,
                    onChanged: (v) => controller.toggleRemove(v),
                  ),
                ),
                const SizedBox(height: 30),
                Obx(() {
                  final enabled = controller.canDelete;
                  return CustomButton(
                    text: 'Delete my account'.tr,
                    onTap: enabled ? controller.deleteAccount : null,
                    width: double.infinity,
                    backgroundColor: enabled
                        ? AppColors.red
                        : const Color(0xFFECEFF0),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
