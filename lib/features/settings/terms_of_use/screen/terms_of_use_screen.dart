import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 78,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: 'Terms of Use', showBackButton: true),
              SizedBox(height: 32),
              Text(
                '1. Introduction',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'RYVENZA is a lifestyle and performance optimization application providing  recommendations based on user inputs such as sleep, nutrition, hydration, caffeine,  and physical activity.  By using the application, you agree to these Terms of Use.',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '2. User Accout',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Users may be required to create an account to access certain features. You are responsible for maintaining the confidentiality of your account credentials.",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '3. Services',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "RYVENZA provides:\n- personalized recommendations\n- lifestyle data analysis\n- lifestyle data analysis\nautomated recommendations based on user inputs and  system logic.  The service may evolve and be updated at any time.",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '4. Subscription',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "RYVENZA offers free and premium features.  Premium features are accessible through paid subscriptions.  Subscriptions may renew automatically unless cancelled.",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '5. Limitation of Liability',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "RYVENZA provides informational recommendations only.  We do not guarantee results, accuracy, or outcomes.  The user remains fully responsible for their decisions and actions.  Users acknowledge that recommendations are generated automatically and may not  be accurate or suitable for their specific situation.",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '6. Acceptable Use',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Users agree not to:\n - misuse the application\n - attempt unauthorized access\n- reproduce or exploit the service",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '7. Suspension',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "We reserve the right to suspend or terminate accounts in case of misuse.",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '8. Modifications',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "We may update these Terms at any time.",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '9. Governing Law',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "These Terms are governed by Swiss law.",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
