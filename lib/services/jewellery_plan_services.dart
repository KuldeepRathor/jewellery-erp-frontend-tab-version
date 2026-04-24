import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:dio/dio.dart' show Options;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/token_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/add_advance_booking/model/add_advance_booking_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/complete_booking/model/complete_booking_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/new_booking/model/new_booking_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/digital_coin_buy_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/setup_digital_coin/model/setup_digital_coin_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/model/add_installment_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/cancel_plan/model/cancel_plan_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/create_subscription_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class JewelleryPlanServices {
  final HttpDioClient _apiService = Get.find();
  final TokenController _tokenController = Get.find();

  // Sales otp
  Future sendOtpForClosePlan(String mobile) async {
    try {
      var formData = dio.FormData.fromMap({'mobile': mobile});
      final accessToken = await _tokenController.getAccessToken();
      final response = await _apiService.post(
        'https://sipserver.1ounce.in',
        '/shop/savings-plan/send_otp_for_close_plan/',
        data: formData,
        options: dio.Options(
          headers: {
            'Accept': 'application/json, text/plain, /',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Orders

  Future getOrdersListing({
    required String search,
    required int page,
    required String status__in,
    String assigned_to_vendor__in = '',
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/customOrders/',
        queryParameters: {
          'search': search,
          'page': page.toString(),
          'assigned_to_vendor__in': assigned_to_vendor__in,
          'status__in': status__in,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Digital Coin Booking
  Future validateOtpDigitalCoin(String mobile, String otp) async {
    try {
      final formData = dio.FormData.fromMap({'mobile': mobile, 'otp': otp});

      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/users/validate_otp_existing_user/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Accept': 'application/json, text/plain, */*',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future sendOtpDigitalCoin(String mobile) async {
    try {
      final formData = dio.FormData.fromMap({'mobile': mobile});

      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/users/send_otp_existing_user/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Accept': 'application/json, text/plain, */*',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future setupDigitalCoin(
    SetupDigitalCoinRequest setup_digital_coin_request,
    int id,
  ) async {
    try {
      final body = jsonEncode(setup_digital_coin_request.toJson());
      final response = await _apiService.patch(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/digital_coin/commodities/$id/',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future newDelivery(String commodity, String weight, String phone) async {
    try {
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/digital_coin/order/new_delivery/',
        data: {'commodity': commodity, 'weight': weight, 'phone': phone},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getUserCommodity({required int id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/digital_coin/user/$id/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDigitalCoinUserData({required String phone}) async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/users/get_user_data/',
        queryParameters: {'phone': phone},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future digitalCoinBuy(DigitalCoinBuyRequest digital_coin_buy_request) async {
    try {
      final body = jsonEncode(digital_coin_buy_request.toJson());
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/digital_coin/order/new/',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future calculteDigitalGold(String commodity, int? amount, int? weight) async {
    try {
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/digital_coin/order/calculate_amount/',
        data: {
          'commodity': commodity,
          if (amount != null) 'amount': amount,
          if (weight != null) 'weight': weight,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getCommodities() async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/digital_coin/commodities/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      // Ensure we return a List
      if (response is List) {
        return response;
      } else if (response is Map<String, dynamic>) {
        return [response];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future getDigitalCoinBuyListing({
    required String category,
    required int page,
    required String limit,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/digital_coin/order/',
        data: {'category': category, 'page': page, "limit": limit},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDigitalCoinDeliveryListing({
    required String category,
    required int page,
    required String limit,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/digital_coin/order/',
        data: {'category': category, 'page': page, "limit": limit},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Advance Booking

  Future getAdvanceBookingSetup() async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/advance_booking/get_setup/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllowedBookings() async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/advance_booking/allowed_booking/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future newBooking(NewBookingRequest newBookingRequest) async {
    try {
      final body = jsonEncode(newBookingRequest.toJson());
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/advance_booking/add_booking/',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addAdvanceBooking(
    AddAdvanceBookingRequest addAdvanceBookingRequest,
  ) async {
    try {
      final body = jsonEncode(addAdvanceBookingRequest.toJson());
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/advance_booking/add_advance/',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future completeBooking(CompleteBookingRequest completeBookingRequest) async {
    try {
      final body = jsonEncode(completeBookingRequest.toJson());
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/advance_booking/complete_booking/',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getBookingListing({
    required String search,
    required int page,
    required String status,
    String ordering = '',
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/advance_booking/',
        queryParameters: {
          'search': search,
          'page': page.toString(),
          'ordering': ordering,
          'status': status,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Setup Plan

  Future getAccounts() async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/offlineBankAccounts/0/get_accounts/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future cancelPlan(CancelPlanRequest cancelPlanRequest) async {
    try {
      final body = jsonEncode(cancelPlanRequest.toJson());
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/cancel_plan/',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addInstallment(AddInstallmentRequest addInstallmentRequest) async {
    try {
      final body = jsonEncode(addInstallmentRequest.toJson());
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/savings-plan/add_installment/',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createSubscription(
    CreateSubscriptionRequest createSubscriptionRequest,
  ) async {
    try {
      final body = jsonEncode(createSubscriptionRequest.toJson());
      final response = await _apiService.post(
        AppUrl.jewelleryPlanBaseUrl,
        '/savings-plan/create_installment/',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getViewInstallment(String id) async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl1,
        '/shop/ledger/$id/get_emis/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSetupPlanListing() async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl,
        '/savings-plan/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getInstallmentData({required String subscription_code}) async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl,
        '/savings-plan/get_installment_data/',
        queryParameters: {'subscription_code': subscription_code},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSavingsPlan() async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl,
        '/savings-plan/get_plans',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getJewelleryPlans({
    required String search,
    required int page,
    required String status,
    String ordering = '-id',
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.jewelleryPlanBaseUrl,
        '/jewellery_plan/',
        queryParameters: {
          'search': search,
          'page': page.toString(),
          'ordering': ordering,
          'status': status,
          'organization_id': "053f7540-b2a9-4134-ac06-05905688ed7e",
        },
        options: Options(
          headers: {
            // 'Authorization': 'Bearer ${_tokenController.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
