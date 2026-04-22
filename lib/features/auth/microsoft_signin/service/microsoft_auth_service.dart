import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../model/user_model.dart';

class MicrosoftAuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  // Microsoft Azure AD Configuration
  static const String _clientId = 'cf8bdbba-cc86-4325-ac13-7ce01c5724ba'; // Replace with your Microsoft App ID
  static const String _redirectUrl = 'https://ryvenza-1d3f0.firebaseapp.com/__/auth/handler'; // Replace with your redirect URL
  static const String _discoveryUrl =
      'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration';

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

      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          discoveryUrl: _discoveryUrl,
          scopes: [
            'openid',
            'profile',
            'email',
          ],
          promptValues: ['login'],
        ),
      );

      debugPrint('Microsoft Sign-In successful');
      debugPrint('Access Token: ${result.accessToken}');

      // Decode the ID token to extract user information
      final tokenData =
          result.idToken != null ? _decodeToken(result.idToken!) : {};

      return UserModel(
        email: tokenData['email'] as String? ?? '',
        fullName: tokenData['name'] as String? ?? '',
      );
        } catch (e) {
      debugPrint('Microsoft Sign-In Error: $e');
      return null;
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
