import 'package:flutter/material.dart';
import 'package:chrisimhof/core/widgets/custom_app_bar.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});
  final const NutritionController nutritionController = NutritionController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomAppBar(title: 'Nutrition',showBackButton: true,showMoreButton: false,showLogo: false,showSettingsButton: false,),
            const SizedBox(height: 28.0),
          ],
      ),
    ));

  }
}