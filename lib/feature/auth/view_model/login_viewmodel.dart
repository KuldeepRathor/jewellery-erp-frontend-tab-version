import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/token_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/user_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/model/login_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/view/otp_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/home_page.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class LoginViewModel extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final loginFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  // Text editing controllers
  final shopIdController = TextEditingController();
  final userIdController = TextEditingController();
  final pinController = TextEditingController();
  final otpController = TextEditingController();

  // Focus nodes
  final FocusNode shopIdFocus = FocusNode();
  final FocusNode userIdFocus = FocusNode();
  final FocusNode pinFocus = FocusNode();
  final FocusNode loginButtonFocus =
      FocusNode(); // New focus node for login button

  // Observable variables for UI state
  final isLoading = false.obs;
  final loginResponse = Rx<ApiResponse<LoginResponse>>(
    ApiResponse.initial("Initial"),
  );

  @override
  void onInit() {
    super.onInit();
    // Initialize focus node behavior for Enter key navigation
    _setupKeyboardListeners();
    _setupLoginButtonFocus();
  }

  void _setupKeyboardListeners() {
    // Set up key event listeners for each focus node
    shopIdFocus.addListener(_handleShopIdFocus);
    userIdFocus.addListener(_handleUserIdFocus);
    pinFocus.addListener(_handlePinFocus);

    // Attach keyboard listeners to focus nodes
    ServicesBinding.instance.keyboard.addHandler(_handleKeyPress);
  }

  void _setupLoginButtonFocus() {
    // Add listener to login button focus to handle Enter key press
    loginButtonFocus.addListener(() {
      if (loginButtonFocus.hasFocus) {
        // This is optional - you could add visual feedback when the login button has focus
      }
    });
  }

  bool _handleKeyPress(KeyEvent event) {
    // Handle Enter key press for navigation between fields
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      FocusNode? currentFocus = FocusManager.instance.primaryFocus;

      if (currentFocus == shopIdFocus && shopIdController.text.isNotEmpty) {
        userIdFocus.requestFocus();
        return true;
      } else if (currentFocus == userIdFocus &&
          userIdController.text.isNotEmpty) {
        pinFocus.requestFocus();
        return true;
      } else if (currentFocus == pinFocus && pinController.text.length == 4) {
        loginButtonFocus.requestFocus(); // Move to login button after PIN entry
        return true;
      } else if (currentFocus == loginButtonFocus) {
        login(); // Trigger login when Enter is pressed on login button
        return true;
      }
    }
    return false;
  }

  void _handleShopIdFocus() {
    if (!shopIdFocus.hasFocus && shopIdController.text.isNotEmpty) {
      userIdFocus.requestFocus();
    }
  }

  void _handleUserIdFocus() {
    if (!userIdFocus.hasFocus && userIdController.text.isNotEmpty) {
      pinFocus.requestFocus();
    }
  }

  void _handlePinFocus() {
    // Optional: You could add logic for when pin focus changes
    if (!pinFocus.hasFocus && pinController.text.length == 4) {
      loginButtonFocus.requestFocus();
    }
  }

  void resetFields() {
    shopIdController.clear();
    userIdController.clear();
    pinController.clear();
    otpController.clear();
    loginResponse.value = ApiResponse.initial("Initial");
  }

  LoginResponse? _loginResponseData;

  Future<void> login() async {
    try {
      if (loginFormKey.currentState!.validate() == false) {
        showErrorToast(message: "Please check the input fields");
        return;
      }

      loginResponse.value = ApiResponse.loading("Logging in...");
      isLoading.value = true;

      final response = await _organizationRepository.login(
        userIdController.text,
        shopIdController.text,
        (pinController.text),
      );
      _loginResponseData = LoginResponse.fromJson(response);

      loginResponse.value = ApiResponse.completed(_loginResponseData);

      // Save both tokens using TokenController
      if (_loginResponseData?.accessToken != null &&
          _loginResponseData?.refreshToken != null) {
        final tokenController = Get.find<TokenController>();
        await tokenController.setTokens(
          _loginResponseData!.accessToken!,
          _loginResponseData!.refreshToken!,
        );
        final userController = Get.find<UserController>();
        userController.setUserData(_loginResponseData!);
      }
      if (_loginResponseData?.isTwoFactorAuthEnabled == true) {
        Get.to(() => const OTPScreen());
      } else {
        Get.offAll(() => const HomePage());
        showSuccessToast(message: "Login successful");
      }
    } catch (e, stack) {
      log('Login error: $e $stack');
      loginResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Login failed. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP() async {
    try {
      if (otpFormKey.currentState?.validate() == false) {
        showErrorToast(message: "Please enter a valid OTP");
        return;
      }

      if (_loginResponseData?.id == null) {
        showErrorToast(message: "Invalid session. Please login again.");
        return;
      }

      isLoading.value = true;
      final response = await _organizationRepository.verifyOtp(
        _loginResponseData!.id!,
        otpController.text,
      );

      // Handle OTP verification response
      if (response != null) {
        showSuccessToast(message: "Login Successfull");
        Get.offAll(() => const HomePage());
      }
    } catch (e) {
      log('OTP verification error: $e');
      showErrorToast(message: "OTP verification failed. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  bool isTokenValid(String token) {
    try {
      // Decode the JWT token
      final parts = token.split('.');
      if (parts.length != 3) return false;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      if (payload['exp'] != null) {
        // Convert Unix timestamp (in seconds) to milliseconds for DateTime
        final expiry = DateTime.fromMillisecondsSinceEpoch(
          payload['exp'] * 1000,
        );
        return DateTime.now().isBefore(expiry);
      }
      return false;
    } catch (e) {
      log('Token validation error: $e');
      return false;
    }
  }

  // Form validation methods
  String? validateShopId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Shop ID is required';
    }
    return null;
  }

  String? validateUserId(String? value) {
    if (value == null || value.isEmpty) {
      return 'User ID is required';
    }
    return null;
  }

  String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    if (value.length != 4) {
      return 'PIN must be 4 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'PIN must contain only numbers';
    }
    return null;
  }

  @override
  void onClose() {
    // Clean up resources
    ServicesBinding.instance.keyboard.removeHandler(_handleKeyPress);

    shopIdFocus.removeListener(_handleShopIdFocus);
    userIdFocus.removeListener(_handleUserIdFocus);
    pinFocus.removeListener(_handlePinFocus);

    // shopIdController.dispose();
    // userIdController.dispose();
    // pinController.dispose();
    // otpController.dispose();

    // shopIdFocus.dispose();
    // userIdFocus.dispose();
    // pinFocus.dispose();
    // loginButtonFocus.dispose(); // Don't forget to dispose the new focus node

    super.onClose();
  }
}
