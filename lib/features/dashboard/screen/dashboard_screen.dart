import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/widget/daily_recommendations.dart';
import 'package:chrisimhof/features/dashboard/widget/list_widget.dart';
import 'package:chrisimhof/features/dashboard/widget/option_button_widget.dart';
import 'package:chrisimhof/features/dashboard/widget/profile_widget.dart';
import 'package:chrisimhof/features/dashboard/widget/the_daily_vitality_score.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: 78, left: 16, bottom: 100),
          child: Column(
            children: [
              ProfileWidget(name: 'Avijit Das'),
              TheDailyVitalityScore(),
              OptionButtonWidget(),
              Obx(
                () => GridView.builder(
                  padding: EdgeInsets.only(right: 16),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.dashboardItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.dashboardItems[index];
                    return ListWidget(
                      title: item.title,
                      image: item.image,
                      percent: item.percent,
                      description: item.description,
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              DailyRecommendations(),
            ],
          ),
        ),
      ),
    );
  }
}
