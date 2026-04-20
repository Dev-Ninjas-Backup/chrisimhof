import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/core/common/widgets/app_translations.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

class Chrisimhof extends StatelessWidget {
  const Chrisimhof({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the LanguageController at app level
    Get.put(LanguageController(), permanent: true);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Get.deviceLocale ?? const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: AppRoutes.getSplashScreen(),
      getPages: AppRoutes.routes,
      builder: EasyLoading.init(),
      themeMode: ThemeMode.light,
    );
  }
}
