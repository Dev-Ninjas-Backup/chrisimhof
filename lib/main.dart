import 'package:chrisimhof/chrisimhof.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final initialLanguage = await SharedPreferencesHelper.getLanguage();
  
  runApp(Chrisimhof(initialLanguage: initialLanguage));
}
