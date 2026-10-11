import 'package:chrisimhof/chrisimhof.dart';
import 'package:chrisimhof/core/service/fcm_service.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final initialLanguage = await SharedPreferencesHelper.getLanguage();

  runApp(Chrisimhof(initialLanguage: initialLanguage));

  // Initialize FCM and print registration token
  FcmService().initialize();
}
