import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/dashboard/caffeine/model/caffeine_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddCaffeineBottomSheet extends StatefulWidget {
  final CaffeineController controller;
  final CaffeineEntry? entry;

  const AddCaffeineBottomSheet({
    super.key,
    required this.controller,
    this.entry,
  });

  static Future<void> show(
    BuildContext context, {
    required CaffeineController controller,
    CaffeineEntry? entry,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCaffeineBottomSheet(
        controller: controller,
        entry: entry,
      ),
    );
  }

  @override
  State<AddCaffeineBottomSheet> createState() => _AddCaffeineBottomSheetState();
}

class _AddCaffeineBottomSheetState extends State<AddCaffeineBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late int _amountMg;
  late DateTime _selectedDateTime;

  bool get isEditMode => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.entry != null ? widget.entry!.title : 'Other'.tr,
    );
    _amountMg = widget.entry?.amountMg ?? 80;
    _amountController = TextEditingController(text: '$_amountMg');
    _selectedDateTime = widget.entry?.timestamp ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _amountMg = (_amountMg + 10).clamp(0, 1000);
      _amountController.text = '$_amountMg';
      _amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: _amountController.text.length),
      );
    });
  }

  void _decrement() {
    if (_amountMg > 10) {
      setState(() {
        _amountMg = (_amountMg - 10).clamp(0, 1000);
        _amountController.text = '$_amountMg';
        _amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: _amountController.text.length),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormatted =
        '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}';
    final dateFormatted = DateFormat(
      'd MMM yyyy',
      Get.locale?.toString(),
    ).format(_selectedDateTime);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header: Coffee Cup Icon + Tag + Title + Close Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFEDD5), width: 1),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.coffee_rounded,
                      size: 22,
                      color: Color(0xFF9A3412),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CAFFEINE'.tr,
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSoft,
                        ).copyWith(letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEditMode
                            ? 'Edit caffeine entry'.tr
                            : 'Add caffeine'.tr,
                        style: getTextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.gray100Alt2,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 1: Nom de la boisson / Drink name
            Text(
              'Drink name'.tr,
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor, width: 1.2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      style: getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Espresso, Coffee, Tea'.tr,
                        hintStyle: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSoft.withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.textSoft,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Section 2: Quantité de caféine / Caffeine amount
            Text(
              'Caffeine amount'.tr,
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 10),

            // Stepper card with center editable TextField
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDBA74), width: 1.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decrement button (-10 mg)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _decrement,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFED7AA),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 20,
                        color: Color(0xFF9A3412),
                      ),
                    ),
                  ),

                  // Center directly editable number + "|" divider + "mg"
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IntrinsicWidth(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.center,
                            style: getTextStyle2(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 2,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              final parsed = int.tryParse(val);
                              if (parsed != null) {
                                _amountMg = parsed;
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 24,
                          width: 1.2,
                          color: const Color(0xFFFED7AA),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        Text(
                          'mg',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Increment button (+10 mg)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _increment,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFED7AA),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xFF9A3412),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Section 3: Date et heure / Date and time
            Text(
              'Date and time'.tr,
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Date Card
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDateTime,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF9A3412),
                                onPrimary: Colors.white,
                                onSurface: AppColors.primaryTextColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            _selectedDateTime.hour,
                            _selectedDateTime.minute,
                          );
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: AppColors.textSoft,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              dateFormatted,
                              style: getTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Time Card
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: _selectedDateTime.hour,
                          minute: _selectedDateTime.minute,
                        ),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF9A3412),
                                onPrimary: Colors.white,
                                onSurface: AppColors.primaryTextColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            _selectedDateTime.year,
                            _selectedDateTime.month,
                            _selectedDateTime.day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: AppColors.textSoft,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeFormatted,
                            style: getTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Action Buttons: [ Annuler ]  [ Ajouter / Enregistrer ]
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel'.tr,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final title = _nameController.text.trim().isNotEmpty
                          ? _nameController.text.trim()
                          : 'Other'.tr;
                      final amount = int.tryParse(_amountController.text) ?? _amountMg;
                      if (amount <= 0) return;
                      final dt = _selectedDateTime;

                      Navigator.of(context).pop();

                      if (isEditMode) {
                        await widget.controller.editCaffeineEntry(
                          widget.entry!.id,
                          title,
                          amount,
                          dt,
                        );
                      } else {
                        await widget.controller.addCaffeineEntry(
                          title,
                          amount,
                          dt,
                        );
                      }
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9A3412),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isEditMode ? 'Save'.tr : 'Add'.tr,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Delete button in edit mode
            if (isEditMode && widget.entry!.id.isNotEmpty) ...[
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.controller.deleteCaffeineEntry(widget.entry!.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFDC2626),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete caffeine entry'.tr,
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
