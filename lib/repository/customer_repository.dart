// feature Repository

import 'dart:developer';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/create_customer_aadhar_presigned_url_save_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/create_customer_pan_presigned_url_save_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_country_code_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_by_id_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/services/customer_services.dart';

class CustomerRepository {
  final CustomerServices addCustomerServices = CustomerServices();

  Future<CustomerPanPresignedUrlSave> customerPanPresignedUrl(
    CustomerPanPresignedUrlSave request,
  ) async {
    try {
      final response = await addCustomerServices.customerPanPresignedUrl(
        request,
      );
      return CustomerPanPresignedUrlSave.fromJson(response);
    } catch (e) {
      log('Error getting PAN presigned URL: $e');
      rethrow;
    }
  }

  Future<CustomerAadharPresignedUrlSave> customerAadharPresignedUrl(
    CustomerAadharPresignedUrlSave request,
  ) async {
    try {
      final response = await addCustomerServices.customerAadharPresignedUrl(
        request,
      );
      return CustomerAadharPresignedUrlSave.fromJson(response);
    } catch (e) {
      log('Error getting Aadhar presigned URL: $e');
      rethrow;
    }
  }

  Future putCustomerPanImage({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await addCustomerServices.putCustomerImage(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading PAN image to S3: $e');
      rethrow;
    }
  }

  Future putCustomerAadharImage({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await addCustomerServices.putCustomerImage(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading Aadhar image to S3: $e');
      rethrow;
    }
  }

  Future<List<GetCountryCodeResponse>> getCountryCode({
    String query = '',
  }) async {
    try {
      final response = await addCustomerServices.getCountryCode(query: query);
      return (response as List)
          .map(
            (item) =>
                GetCountryCodeResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> gst_phone_number_availability(
    String type_value,
    String type,
  ) async {
    final response = await addCustomerServices.gst_phone_number_availability(
      type_value,
      type,
    );
    return response["is_available"] ?? false;
  }

  Future<CustomerDetails> addCustomer(CustomerDetails customerData) async {
    final response = await addCustomerServices.addCustomer(customerData);
    return CustomerDetails.fromJson(response);
  }

  // Future<GetCustomerRequestResponse> getCustomer(String query) async {
  //   final response = await addCustomerServices.getCustomer(query);
  //   return GetCustomerRequestResponse.fromJson(response);
  // }
  Future<GetCustomerByIdResponse> getCustomer(String customerId) async {
    final response = await addCustomerServices.getCustomeById(customerId);
    return GetCustomerByIdResponse.fromJson(response);
  }

  Future<CustomerDetails> putCustomer(
    String customerId,
    CustomerDetails customerData,
  ) async {
    try {
      final response = await addCustomerServices.putCustomer(
        customerId,
        customerData,
      );
      return CustomerDetails.fromJson(response);
    } catch (e) {
      log("Error editing customer: $e");
      rethrow;
    }
  }

  Future<void> updateForcedKycPan({
    required String customerId,
    required bool isForcedKycPan,
  }) async {
    try {
      await addCustomerServices.updateForcedKycPan(
        customerId: customerId,
        isForcedKycPan: isForcedKycPan,
      );
    } catch (e) {
      log("Error updating forced KYC PAN: $e");
      rethrow;
    }
  }

  Future<void> updateForcedKycAadhaar({
    required String customerId,
    required bool isForcedKycAadhaar,
  }) async {
    try {
      await addCustomerServices.updateForcedKycAadhaar(
        customerId: customerId,
        isForcedKycAadhaar: isForcedKycAadhaar,
      );
    } catch (e) {
      log("Error updating forced KYC Aadhaar: $e");
      rethrow;
    }
  }
}
