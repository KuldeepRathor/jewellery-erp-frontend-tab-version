import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/token_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/model/login_response.dart';

class UserController extends GetxController {
  // Observable user data
  final Rx<LoginResponse?> userData = Rx<LoginResponse?>(null);

  // TokenController instance
  final TokenController _tokenController = Get.find<TokenController>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Load user data from stored token
  Future<void> loadUserData() async {
    try {
      final accessToken = await _tokenController.getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        final Map<String, dynamic> responseData = {
          "access_token": accessToken,
          "refresh_token": await _tokenController.getRefreshToken(),
          "token_type": "Bearer",
          "is_two_factor_auth_enabled": false,
        };

        userData.value = LoginResponse.fromJson(responseData);
        log('User data loaded successfully');
      } else {
        log('No access token found');
      }
    } catch (e) {
      log('Error loading user data: $e');
    }
  }

  /// Set user data after login
  void setUserData(LoginResponse loginResponse) {
    userData.value = loginResponse;
    log('User data set successfully');
  }

  /// Clear user data on logout
  void clearUserData() {
    userData.value = null;
    log('User data cleared');
  }

  /// Refresh user data from token
  Future<void> refreshUserData() async {
    await loadUserData();
  }

  // Convenient getters for commonly used properties
  String? get userId => userData.value?.id;
  String? get userName => userData.value?.roleName;
  String? get organizationName => userData.value?.organizationName;
  String? get organizationId => userData.value?.organizationId;
  String? get shopId => userData.value?.shopId;
  String? get branchReadableId => userData.value?.branchReadableId;
  String? get roleReadableId => userData.value?.roleReadableId;
  String? get roleType => userData.value?.roleType;
  List<int>? get modules => userData.value?.modules;
  int? get userIdInt => userData.value?.userId;
  DateTime? get tokenExpiration => userData.value?.expirationDate;

  /// Check if user has specific module access
  bool hasModuleAccess(int moduleId) {
    return modules?.contains(moduleId) ?? false;
  }

  /// Check if token is expired
  bool get isTokenExpired {
    if (tokenExpiration == null) return true;
    return DateTime.now().isAfter(tokenExpiration!);
  }

  /// Get formatted user display string
  String get userDisplayString {
    if (userData.value == null) return '';
    return '${userData.value?.branchReadableId ?? ""}/${userData.value?.roleReadableId ?? ""}';
  }
}
