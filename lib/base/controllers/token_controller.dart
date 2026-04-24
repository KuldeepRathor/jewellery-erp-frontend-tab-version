import 'dart:async';

import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/user_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/view/login_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String TOKEN_KEY = 'access_token';
const String REFRESH_TOKEN_KEY = 'refresh_token';

class TokenController extends GetxController {
  final _token = Rxn<String>();
  String? get token => _token.value;

  @override
  void onInit() {
    super.onInit();
    loadSavedToken();
  }

  Future<void> loadSavedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedToken = prefs.getString(TOKEN_KEY);
      if (savedToken != null) {
        _token.value = savedToken;
      }
      log('Loaded saved token: $savedToken');
    } catch (e) {
      log('Error loading token: $e');
    }
  }

  Future<void> setToken(String newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(TOKEN_KEY, newToken);
      _token.value = newToken;
      await Get.find<RBACController>().extractPermissionsFromToken();

      log('New token set: $newToken');
    } catch (e) {
      log('Error setting token: $e');
      rethrow;
    }
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(TOKEN_KEY, accessToken);
      await prefs.setString(REFRESH_TOKEN_KEY, refreshToken);
      _token.value = accessToken;
      await Get.find<RBACController>().extractPermissionsFromToken();
      log('New tokens set');
    } catch (e) {
      log('Error setting tokens: $e');
      rethrow;
    }
  }

  Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(TOKEN_KEY);
      await prefs.remove(REFRESH_TOKEN_KEY);
      _token.value = null;
      log('Tokens cleared');
    } catch (e) {
      log('Error clearing tokens: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await clearToken();
    try {
      Get.find<UserController>().clearUserData();
    } catch (e) {
      log('UserController not found during logout');
    }
    Get.offAll(() => const LoginScreen());
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString(TOKEN_KEY);
    return accessToken;
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString(REFRESH_TOKEN_KEY);
    return accessToken;
  }
}
