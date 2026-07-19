import 'package:chrisimhof/core/binder/controller_binder.dart';
import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/core/common/widgets/app_translations.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

class Chrisimhof extends StatelessWidget {
  final String? initialLanguage;

  const Chrisimhof({super.key, this.initialLanguage});

  @override
  Widget build(BuildContext context) {
    // Initialize the LanguageController at app level
    final languageController = Get.put(LanguageController(), permanent: true);

    // If initialLanguage is provided, set it in the language controller immediately
    if (initialLanguage != null) {
      languageController.selectedLanguage.value = initialLanguage!.toUpperCase();
    }

    final Locale initialLocale;
    if (initialLanguage?.toUpperCase() == 'FR') {
      initialLocale = const Locale('fr', 'FR');
    } else if (initialLanguage?.toUpperCase() == 'EN') {
      initialLocale = const Locale('en', 'US');
    } else {
      initialLocale = Get.deviceLocale ?? const Locale('en', 'US');
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      translations: AppTranslations(),
      locale: initialLocale,
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

