import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/calculator/results/controller/calculator_results_controller.dart';
import 'package:chrisimhof/features/calculator/results/model/calculator_results_model.dart';
import 'package:chrisimhof/features/calculator/results/widgets/results_metric_card.dart';
import 'package:chrisimhof/features/calculator/results/widgets/results_overall_state_card.dart';
import 'package:chrisimhof/features/calculator/results/widgets/results_recommendations_card.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorResultsScreen extends StatefulWidget {
  final CalculatorResultsData initialData;

  const CalculatorResultsScreen({super.key, required this.initialData});

  @override
  State<CalculatorResultsScreen> createState() =>
      _CalculatorResultsScreenState();
}

class _CalculatorResultsScreenState extends State<CalculatorResultsScreen> {
  late final String _tag;
  late final CalculatorResultsController _controller;

  @override
  void initState() {
    super.initState();
    _tag = DateTime.now().microsecondsSinceEpoch.toString();
    _controller = Get.put(
      CalculatorResultsController(initialData: widget.initialData),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<CalculatorResultsController>(tag: _tag)) {
      Get.delete<CalculatorResultsController>(tag: _tag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          final resultData = _controller.resultData.value;

          if (_controller.isLoading.value && resultData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (resultData == null) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(title: 'Results', showBackButton: true),
                const SizedBox(height: 24),
                ResultsOverallStateCard(
                  score: resultData.overallScore,
                  label: resultData.overallLabel,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resultData.metrics.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.98,
                  ),
                  itemBuilder: (context, index) {
                    return ResultsMetricCard(metric: resultData.metrics[index]);
                  },
                ),
                const SizedBox(height: 16),
                ResultsRecommendationsCard(
                  recommendations: resultData.recommendations,
                ),
                const SizedBox(height: 24),
                CustomButton(text: 'Recalculate', onTap: Get.back),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Go To Dashboard',
                  onTap: () => Get.offAll(() => const NavbarScreen()),
                  backgroundColor: const Color(0xFFF4F4F8),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
