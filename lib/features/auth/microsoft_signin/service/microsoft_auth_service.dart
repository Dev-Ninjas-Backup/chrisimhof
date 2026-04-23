import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

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
  static const AuthorizationServiceConfiguration _serviceConfiguration =
      AuthorizationServiceConfiguration(
        authorizationEndpoint:
            'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        tokenEndpoint:
            'https://login.microsoftonline.com/common/oauth2/v2.0/token',
      );
  static const List<String> _scopes = ['offline_access', 'User.Read'];
  static const String _graphMeEndpoint = 'https://graph.microsoft.com/v1.0/me';

  Future<UserModel> _fetchUserProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse(_graphMeEndpoint),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Graph profile request failed: ${response.statusCode} ${response.body}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    final email = (data['mail'] as String?)?.trim();
    final principalName = (data['userPrincipalName'] as String?)?.trim();
    final fullName = (data['displayName'] as String?)?.trim();

    return UserModel(
      email: (email?.isNotEmpty ?? false)
          ? email!
          : (principalName?.isNotEmpty ?? false)
          ? principalName!
          : '',
      fullName: (fullName?.isNotEmpty ?? false) ? fullName! : '',
    );
  }

  /// Kept for optional debug logging when an ID token is returned.
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
              serviceConfiguration: _serviceConfiguration,
              scopes: _scopes,
              promptValues: ['login'],
            ),
          );

      debugPrint('Microsoft Sign-In successful');
      debugPrint('Access Token: ${result.accessToken}');
      if (result.idToken != null) {
        debugPrint('ID Token payload: ${_decodeToken(result.idToken!)}');
      }

      final accessToken = result.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Microsoft access token missing from token response');
      }

      return _fetchUserProfile(accessToken);
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
