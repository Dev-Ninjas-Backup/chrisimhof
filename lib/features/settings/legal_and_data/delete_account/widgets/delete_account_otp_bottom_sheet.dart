import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/controller/delete_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class DeleteAccountOtpBottomSheet extends StatefulWidget {
  final DeleteAccountController controller;

  const DeleteAccountOtpBottomSheet({super.key, required this.controller});

  @override
  State<DeleteAccountOtpBottomSheet> createState() =>
      _DeleteAccountOtpBottomSheetState();
}

class _DeleteAccountOtpBottomSheetState
    extends State<DeleteAccountOtpBottomSheet> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: getTextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryTextColor,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft, width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFFDC2626), width: 1.5),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: AppColors.white,
      border: Border.all(color: AppColors.gray300, width: 1),
    );

    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 20
            : MediaQuery.of(context).padding.bottom + 36,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Red warning icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFDC2626),
                size: 28,
              ),
            ),
            const SizedBox(height: 14),

            Text(
              'Confirm Account Deletion'.tr,
              style: getTextStyle2(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'A 6-digit verification code has been sent to your registered email address. Enter it below to permanently delete your account.'
                  .tr,
              style: getTextStyle(
                fontSize: 13,
                color: AppColors.textSoft,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // OTP Pinput
            Pinput(
              length: 6,
              controller: _otpController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              showCursor: true,
            ),
            const SizedBox(height: 20),

            // Resend code
            TextButton(
              onPressed: () => widget.controller.resendOtp(),
              child: Text(
                'Resend code'.tr,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryButtonColor,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Confirm Delete Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.controller.isDeleteLoading.value
                      ? null
                      : () {
                          final otp = _otpController.text.trim();
                          if (otp.length != 6) {
                            Get.snackbar(
                              'Invalid Code'.tr,
                              'Please enter the 6-digit verification code.'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          Navigator.of(context).pop();
                          widget.controller.confirmDeletionWithOtp(otp);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.controller.isDeleteLoading.value
                        ? 'Deleting account...'.tr
                        : 'Confirm & Delete Permanently'.tr,
                    style: getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
