// feature Repository

import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/add_advance_booking/model/add_advance_booking_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/booking_listing/model/get_booking_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/complete_booking/model/complete_booking_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/new_booking/model/get_allowed_booking_repsonse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/new_booking/model/new_booking_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/setup_advance_booking/model/get_setup_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/digital_coin_booking_listing/model/digital_coin_buy_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/digital_coin_booking_listing/model/digital_coin_delivery_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/model/get_digital_coin_user_data_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/model/get_user_commodity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/calculate_amount_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/digital_coin_buy_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/get_commodities_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/setup_digital_coin/model/setup_digital_coin_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/model/add_installment_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/model/get_accounts_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/cancel_plan/model/cancel_plan_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/customer_ledger_listing/model/get_jewellery_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/create_subscription_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/get_installment_data_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/get_savings_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/view_installment/model/get_view_installment_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_orders_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_setup_plan_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/send_jewellery_plan_otp_response.dart';
import 'package:jewellery_erp_frontend_tab_version/services/jewellery_plan_services.dart';

class JewelleryPlanRepository {
  final JewelleryPlanServices jewelleryPlanServices = JewelleryPlanServices();

  // sales otp
  Future<SendOtpResponse> sendOtpForClosePlan(String mobile) async {
    final response = await jewelleryPlanServices.sendOtpForClosePlan(mobile);
    final data = SendOtpResponse.fromJson(response);
    return data;
  }

  //order

  Future<GetOrdersListingResponse> getOrdersListing({
    required String search,
    required int page,
    required String status__in,
    String assigned_to_vendor__in = '',
  }) async {
    try {
      final response = await jewelleryPlanServices.getOrdersListing(
        search: search,
        page: page,
        assigned_to_vendor__in: assigned_to_vendor__in,
        status__in: status__in,
      );
      return GetOrdersListingResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Digital Coin Booking

  Future validateOtpDigitalCoin(String mobile, String otp) async {
    try {
      final response = await jewelleryPlanServices.validateOtpDigitalCoin(
        mobile,
        otp,
      );
      return (response);
    } catch (e) {
      rethrow;
    }
  }

  Future sendOtpDigitalCoin(String mobile) async {
    try {
      final response = await jewelleryPlanServices.sendOtpDigitalCoin(mobile);
      return (response);
    } catch (e) {
      rethrow;
    }
  }

  Future<SetupDigitalCoinRequest> setupDigitalCoin(
    SetupDigitalCoinRequest setup_digital_coin_request,
    int id,
  ) async {
    final response = await jewelleryPlanServices.setupDigitalCoin(
      setup_digital_coin_request,
      id,
    );
    return SetupDigitalCoinRequest.fromJson(response);
  }

  Future newDelivery(String commodity, String weight, String phone) async {
    try {
      final response = await jewelleryPlanServices.newDelivery(
        commodity,
        weight,
        phone,
      );
      return (response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetUserCommodityResponse> getUserCommodity({required int id}) async {
    try {
      final response = await jewelleryPlanServices.getUserCommodity(id: id);
      return GetUserCommodityResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetDigitalCoinUserDataResponse> getDigitalCoinUserData({
    required String phone,
  }) async {
    try {
      final response = await jewelleryPlanServices.getDigitalCoinUserData(
        phone: phone,
      );
      return GetDigitalCoinUserDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DigitalCoinBuyRequest> digitalCoinBuy(
    DigitalCoinBuyRequest digital_coin_buy_request,
  ) async {
    final response = await jewelleryPlanServices.digitalCoinBuy(
      digital_coin_buy_request,
    );
    return DigitalCoinBuyRequest.fromJson(response);
  }

  Future<CalculateAmountResponse> calculteDigitalGold(
    String commodity,
    int? amount,
    int? weight,
  ) async {
    try {
      final response = await jewelleryPlanServices.calculteDigitalGold(
        commodity,
        amount,
        weight,
      );
      return CalculateAmountResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetCommoditiesResponse>> getCommodities() async {
    try {
      final response = await jewelleryPlanServices.getCommodities();
      return response
          .map((item) => GetCommoditiesResponse.fromJson(item))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<DigitalCoinBuyListingResponse> getDigitalCoinBuyListing({
    required String category,
    required int page,
    required String limit,
  }) async {
    try {
      final response = await jewelleryPlanServices.getDigitalCoinBuyListing(
        category: category,
        page: page,
        limit: limit,
      );
      return DigitalCoinBuyListingResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DigitalCoinDeliveryListingResponse> getDigitalCoinDeliveryListing({
    required String category,
    required int page,
    required String limit,
  }) async {
    try {
      final response = await jewelleryPlanServices
          .getDigitalCoinDeliveryListing(
            category: category,
            page: page,
            limit: limit,
          );
      return DigitalCoinDeliveryListingResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //Advance Booking

  Future<GetAdvanceBookingSetupResponse> getAdvanceBookingSetup() async {
    try {
      final response = await jewelleryPlanServices.getAdvanceBookingSetup();
      return GetAdvanceBookingSetupResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetAllowedBookingResponse> getAllowedBookings() async {
    try {
      final response = await jewelleryPlanServices.getAllowedBookings();
      return GetAllowedBookingResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> newBooking(NewBookingRequest newBookingRequest) async {
    final response = await jewelleryPlanServices.newBooking(newBookingRequest);
    return NewBookingRequest.fromJson(response);
  }

  Future<AddAdvanceBookingRequest> addAdvanceBooking(
    AddAdvanceBookingRequest addAdvanceBookingRequest,
  ) async {
    final response = await jewelleryPlanServices.addAdvanceBooking(
      addAdvanceBookingRequest,
    );
    return AddAdvanceBookingRequest.fromJson(response);
  }

  Future<CompleteBookingRequest> completeBooking(
    CompleteBookingRequest completeBookingRequest,
  ) async {
    final response = await jewelleryPlanServices.completeBooking(
      completeBookingRequest,
    );
    return CompleteBookingRequest.fromJson(response);
  }

  Future<GetBookingListingResponse> getBookingListing({
    required String search,
    required int page,
    required String status,
    String ordering = '-id',
  }) async {
    try {
      final response = await jewelleryPlanServices.getBookingListing(
        search: search,
        page: page,
        ordering: ordering,
        status: status,
      );
      return GetBookingListingResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //Setup Plan
  Future<GetAccountsResponse> getAccounts() async {
    try {
      final response = await jewelleryPlanServices.getAccounts();
      return GetAccountsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CancelPlanRequest> cancelPlan(
    CancelPlanRequest cancelPlanRequest,
  ) async {
    final response = await jewelleryPlanServices.cancelPlan(cancelPlanRequest);
    return CancelPlanRequest.fromJson(response);
  }

  Future<AddInstallmentRequest> addInstallment(
    AddInstallmentRequest addInstallmentRequest,
  ) async {
    final response = await jewelleryPlanServices.addInstallment(
      addInstallmentRequest,
    );
    return AddInstallmentRequest.fromJson(response);
  }

  Future<CreateSubscriptionRequest> createSubscription(
    CreateSubscriptionRequest createSubscriptionRequest,
  ) async {
    final response = await jewelleryPlanServices.createSubscription(
      createSubscriptionRequest,
    );
    return CreateSubscriptionRequest.fromJson(response);
  }

  Future<GetViewInstallmentResponse> getViewInstallment(String id) async {
    try {
      final response = await jewelleryPlanServices.getViewInstallment(id);
      return GetViewInstallmentResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetSetupPlanListingResponse> getSetupPlanListing() async {
    try {
      final response = await jewelleryPlanServices.getSetupPlanListing();
      return GetSetupPlanListingResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetInstallmentDataResponse> getInstallmentData({
    required String subscription_code,
  }) async {
    try {
      final response = await jewelleryPlanServices.getInstallmentData(
        subscription_code: subscription_code,
      );
      return GetInstallmentDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetSavingsPlanResponseModel> getSavingsPlan() async {
    try {
      final response = await jewelleryPlanServices.getSavingsPlan();
      return GetSavingsPlanResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetJewelleryPlanResponseModel> getJewelleryPlans({
    required String search,
    required int page,
    required String status,
    String ordering = '-id',
  }) async {
    try {
      final response = await jewelleryPlanServices.getJewelleryPlans(
        search: search,
        page: page,
        ordering: ordering,
        status: status,
      );
      return GetJewelleryPlanResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
