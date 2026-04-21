import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart';

class GoogleAuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<UserModel?> signIn() async {
    try {

      await _googleSignIn.initialize();

      final GoogleSignInAccount account =
          await _googleSignIn.authenticate();

      return UserModel(
        email: account.email,
        fullName: account.displayName ?? "",
      );

    } catch (e) {

      debugPrint("Google Sign-In Error: $e");
      return null;

    }
  }
}