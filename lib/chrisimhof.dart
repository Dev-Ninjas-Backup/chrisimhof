import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Chrisimhof extends StatelessWidget {
  const Chrisimhof({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.getMedicalDisclaimerScreen(),
      getPages: AppRoutes.routes,
      builder: EasyLoading.init(),
      themeMode: ThemeMode.light,
    );
  }
}
