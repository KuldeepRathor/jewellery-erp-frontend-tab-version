// Feature View Model
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';

class FeatureViewModel with ChangeNotifier {
  // Initialize the required variables with model
  final ApiResponse<String> _apiResponse = ApiResponse.initial('Empty data');

  // Make necessary Functions

  // Example
  // Future generateMobileOtp(String mobileNumber) async {
  //   _apiResponse = ApiResponse.loading('Generating OTP');
  //   notifyListeners();
  //   try {
  //     SingleMessageResponse singleMessageResponseData =
  //         await AuthenticationRepository().generateMobileOtp(mobileNumber);
  //     setSingleMessageResponse(singleMessageResponseData);
  //     _apiResponse = ApiResponse.completed(singleMessageResponseData);
  //   } catch (e) {
  //     _apiResponse = ApiResponse.error(e.toString());
  //     print(e);
  //   }
  //   notifyListeners();
  // }
}
