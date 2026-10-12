import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../model/user_model.dart';

class AppleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> signIn() async {
    try {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      final UserCredential userCredential =
          await _auth.signInWithProvider(appleProvider);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) return null;

      final email = firebaseUser.email ?? '';
      final fullName = (firebaseUser.displayName?.trim().isNotEmpty ?? false)
          ? firebaseUser.displayName!.trim()
          : (email.isNotEmpty ? email.split('@').first : 'Apple User');

      return UserModel(
        email: email,
        fullName: fullName,
      );
    } catch (e) {
      debugPrint('Apple Sign-In Auth Error: $e');
      return null;
    }
  }
}
