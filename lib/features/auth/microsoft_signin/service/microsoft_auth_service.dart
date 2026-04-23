import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../model/user_model.dart';

class MicrosoftAuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  // Microsoft Azure AD Configuration
  static const String _clientId =
      'de51be26-02d9-41a1-9c0b-9e3b4050aaf0'; // Replace with your Microsoft App ID
  static const String _androidRedirectUrl =
      'msauth://com.ryvenza.app/eCjfdTT0ePbJMhw4XEgNcp01Wsg=';
  static const String _iosRedirectUrl =
      'com.ryvenza.app://auth'; // Must also be registered in the Microsoft app
  static const String _issuer =
      'https://login.microsoftonline.com/19458893-1d91-4953-ab51-55f25565d1d5/v2.0';

  /// Decodes the JWT ID token to extract user information
  Map<String, dynamic> _decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        debugPrint('Invalid token format');
        return {};
      }

      // Decode the payload (second part)
      String payload = parts[1];

      // Add padding if necessary
      final paddingNeeded = 4 - (payload.length % 4);
      if (paddingNeeded != 4) {
        payload += '=' * paddingNeeded;
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error decoding token: $e');
      return {};
    }
  }

  Future<UserModel?> signIn() async {
    try {
      debugPrint('Starting Microsoft Sign-In...');

      final redirectUrl = Platform.isAndroid
          ? _androidRedirectUrl
          : _iosRedirectUrl;

      final AuthorizationTokenResponse result = await _appAuth
          .authorizeAndExchangeCode(
            AuthorizationTokenRequest(
              _clientId,
              redirectUrl,
              issuer: _issuer,
              scopes: ['openid', 'profile', 'email'],
              promptValues: ['login'],
            ),
          );

      debugPrint('Microsoft Sign-In successful');
      debugPrint('Access Token: ${result.accessToken}');

      // Decode the ID token to extract user information
      final tokenData = result.idToken != null
          ? _decodeToken(result.idToken!)
          : {};

      return UserModel(
        email: tokenData['email'] as String? ?? '',
        fullName: tokenData['name'] as String? ?? '',
      );
    } on FlutterAppAuthUserCancelledException catch (e) {
      debugPrint('Microsoft Sign-In cancelled: $e');
      return null;
    } on FlutterAppAuthPlatformException catch (e) {
      debugPrint('Microsoft Sign-In platform error: ${e.details}');
      rethrow;
    } catch (e) {
      debugPrint('Microsoft Sign-In Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      // Sign out logic if needed
      debugPrint('Microsoft Sign-Out');
    } catch (e) {
      debugPrint('Microsoft Sign-Out Error: $e');
    }
  }
}
