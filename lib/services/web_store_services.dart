import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/update_webstore_settings_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/update_webstore_view_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/catalog_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/banners_onexone_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/update_onexone_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/2x2_banner_upload/model/banners_onexone_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/2x2_banner_upload/model/update_onexone_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/4x4_banner_upload/model/banners_fourxfour_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/4x4_banner_upload/model/update_fourxfour_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/model/category_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/model/collection_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/banner_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/create_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/update_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/model/customer_feedback_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class WebStoreServices {
  final HttpDioClient _apiService = Get.find();

  Future updateWebstoreViewSettings(
    UpdateWebstoreViewSettingsRequest updateWebstoreViewSettingsRequest,
  ) async {
    try {
      final body = jsonEncode(updateWebstoreViewSettingsRequest.toJson());
      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/update-webstore-view',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateWebstoreSettings(
    UpdateWebstoreSettingsRequest updateWebstoreSettingsRequest,
  ) async {
    try {
      final body = jsonEncode(updateWebstoreSettingsRequest.toJson());
      final response = await _apiService.put(
        AppUrl.organizationBaseUrl,
        '/update-general-org-settings',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getWebstoreSettings() async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/get-webstore-settings',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getStockHeadsWebViewListing() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/stock-heads-web-view-listing',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDesignWebViewListing() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/design-web-view-listing',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //4X4 banners apis

  Future bannersFourXFourImagePresignedUrl(
    BannersFourXFourImagePresignedUrlRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/banners-fourXfour-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putBannerFourXFourImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateBannerFourXFour(
    List<UpdateBannersFourXFourRequest> bannerRequests,
  ) async {
    try {
      final body = jsonEncode(bannerRequests);

      final response = await _apiService.put(
        AppUrl.webStoreBaseUrl,
        '/update-banner-fourXfour',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllFourXFourBanners({bool? is_webstore}) async {
    try {
      final response = await _apiService.get(
        AppUrl.webStoreBaseUrl,
        '/all-banners-fourXfour',
        queryParameters: {"is_webstore": is_webstore},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //2X2 banners apis

  Future bannersTwoXTwoImagePresignedUrl(
    BannersTwoXTwoImagePresignedUrlRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/banners-twoXtwo-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putBannerTwoXTwoImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateBannerTwoXTwo(
    List<UpdateBannersTwoXTwoRequest> bannerRequests,
  ) async {
    try {
      final body = jsonEncode(bannerRequests);

      final response = await _apiService.put(
        AppUrl.webStoreBaseUrl,
        '/update-banner-twoXtwo',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllTwoXTwoBanners({bool? is_webstore}) async {
    try {
      final response = await _apiService.get(
        AppUrl.webStoreBaseUrl,
        '/all-banners-twoXtwo',
        queryParameters: {"is_webstore": is_webstore},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //1X1 banners apis

  Future bannersOneXOneImagePresignedUrl(
    BannersOneXOneImagePresignedUrlRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/banners-oneXone-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putBannerOneXOneImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateBannerOneXOne(
    List<UpdateBannersOneXOneRequest> bannerRequests,
  ) async {
    try {
      final body = jsonEncode(bannerRequests);

      final response = await _apiService.put(
        AppUrl.webStoreBaseUrl,
        '/update-banner-oneXone',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllOneXOneBanners({bool? is_webstore}) async {
    try {
      final response = await _apiService.get(
        AppUrl.webStoreBaseUrl,
        '/all-banners-oneXone',
        queryParameters: {"is_webstore": is_webstore},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //customer feedback
  Future updateCustomerFeedback(
    List<Map<String, dynamic>> collectionRequests,
  ) async {
    try {
      final body = jsonEncode(collectionRequests);

      final response = await _apiService.put(
        AppUrl.webStoreBaseUrl,
        '/update-customer-feedback',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future customerFeedbackImagePresignedUrl(
    FeedbackPresignedUrlSaveRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/feedback-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putCustomerFeedbackImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllCustomerFeedback() async {
    try {
      final response = await _apiService.get(
        AppUrl.webStoreBaseUrl,
        '/get-all-customer-feedback',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //collection apis
  Future updateCollection(List<Map<String, dynamic>> collectionRequests) async {
    try {
      final body = jsonEncode(collectionRequests);

      final response = await _apiService.put(
        AppUrl.webStoreBaseUrl,
        '/update-collection-webstore',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future collectionImagePresignedUrl(
    CollectionImagesPresignedUrlRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/collection-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putCollectionImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllCollections({bool? is_webstore}) async {
    try {
      final response = await _apiService.get(
        AppUrl.webStoreBaseUrl,
        '/get-all-collection',
        queryParameters: {"is_webstore": is_webstore},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //update categories
  Future updateCategories(List<Map<String, dynamic>> categoryRequests) async {
    try {
      final body = jsonEncode(categoryRequests);

      final response = await _apiService.put(
        AppUrl.webStoreBaseUrl,
        '/update-category',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future categoryImagePresignedUrl(
    CategoryImagesPresignedUrlRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/category-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putCategoryImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllCategories({bool? is_webstore}) async {
    try {
      final response = await _apiService.get(
        AppUrl.webStoreBaseUrl,
        '/all-categories',
        queryParameters: {"is_webstore": is_webstore},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //hero slide banner apis
  Future bannerImagePresignedUrl(
    BannerImagesPresignedUrlRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/banner-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putBannerImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateBanners(List<UpdateBannerRequest> bannerRequests) async {
    try {
      final body = jsonEncode(bannerRequests);

      final response = await _apiService.put(
        AppUrl.webStoreBaseUrl,
        '/update-banner',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //not in use anymore
  Future createBanners(List<CreateBannerRequest> bannerRequests) async {
    try {
      final requestList =
          bannerRequests.map((request) => request.toJson()).toList();
      final body = jsonEncode(requestList);

      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/banner',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllBanners({bool? is_webstore}) async {
    try {
      final response = await _apiService.get(
        AppUrl.webStoreBaseUrl,
        '/get-all-banners',
        queryParameters: {"is_webstore": is_webstore},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getOrderListing({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/webstore-orders-listing?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/webstore-orders-listing?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.get(
        // AppUrl.localBaseUrl,
        // '/customer_details?_page=$page&_per_page=$limit&name=$search',
        AppUrl.aggregateBaseUrl,
        path,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getWebStoreOrderDetail(String orderId) async {
    try {
      final response = await _apiService.get(
        AppUrl.webStoreBaseUrl,
        "/pos/get-webstore-order-line-item-details/$orderId",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> onWebStoreStatusChange(orderItemId, Map data) async {
    try {
      final response = await _apiService.put(
        AppUrl.aggregateBaseUrl,
        "/pos/webstore-orders-status/$orderItemId",
        data: data,
      );
      log("v moneesh$response");
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future getWebStoreSettlements({
    String? offsetId,
    int limit = 10,
    String query = '',
    String? dateFrom,
    String? dateTo,
    List<int>? gatewayType,
  }) async {
    // Fix the path construction - use ? for query params
    String path = '/paginated-settlements?limit=$limit';

    if (offsetId != null) {
      path += '&offset_id=$offsetId';
    }

    if (query.isNotEmpty) {
      path += '&query=$query';
    }

    // Prepare request body
    Map<String, dynamic> body = {};

    if (dateFrom != null) {
      body['date_from'] = dateFrom;
    }

    if (dateTo != null) {
      body['date_to'] = dateTo;
    }

    if (gatewayType != null && gatewayType.isNotEmpty) {
      body['gateway_type'] = gatewayType;
    }

    try {
      log("The query will be $query with body: $body");
      // Use POST instead of GET
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSettlementDetails({
    required String settlementId,
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path = '/settlement-details/$settlementId?limit=$limit';

    if (offsetId != null) {
      path += '&offset_id=$offsetId';
    }

    if (query.isNotEmpty) {
      path += '&query=$query';
    }

    try {
      log("Getting settlement details for ID: $settlementId");
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future shippingStatusImagePresignedUrl(
    CatalogImagesPresignedUrlRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.webStoreBaseUrl,
        '/webstore-order-shipping-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putShippingImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': lookupMimeType(imagePath).toString()},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
