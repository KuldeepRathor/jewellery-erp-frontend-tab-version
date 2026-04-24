// feature Repository

import 'package:jewellery_erp_frontend_tab_version/services/feature_services.dart';

class FeatureRepository {
  // Initialize Feature Service
  final FeatureServices featureServices = FeatureServices();

  // Make the response into a typed structure

  // Example
  // Future<SingleMessageResponse> generateMobileOtp(String mobileNumber) async {
  //   dynamic response =
  //       await _authenticationService.generateMobileOtp(mobileNumber);
  //   final responseData = SingleMessageResponse.fromJson(response);
  //   return responseData;
  // }
}
