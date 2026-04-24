import 'dart:developer';

import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/get_design_web_view_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/get_stock_heads_web_view_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/get_webstore_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/update_webstore_settings_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/update_webstore_view_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/catalog_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/banners_onexone_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/get_all_banners_onexone_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/update_onexone_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/2x2_banner_upload/model/banners_onexone_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/2x2_banner_upload/model/get_all_banners_twoxtwo_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/2x2_banner_upload/model/update_onexone_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/4x4_banner_upload/model/banners_fourxfour_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/4x4_banner_upload/model/get_all_banners_fourxfour_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/4x4_banner_upload/model/update_fourxfour_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/model/category_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/model/get_all_categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/model/update_category_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/model/collection_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/model/get_all_collection_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/model/update_collection_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/banner_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/create_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/get_all_banners_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/update_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/model/customer_feedback_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/model/get_all_customer_feedback_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/model/update_customer_feedback_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/get_webstore_order_detail_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/pagination_get_order_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/model/get_settlements_details_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/model/get_settlements_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/services/web_store_services.dart';

class WebstoreRepository {
  final WebStoreServices webStoreServices = WebStoreServices();

  Future<dynamic> updateWebstoreViewSettings(
    UpdateWebstoreViewSettingsRequest updateWebstoreViewSettingsRequest,
  ) async {
    try {
      final response = await webStoreServices.updateWebstoreViewSettings(
        updateWebstoreViewSettingsRequest,
      );
      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<dynamic> updateWebstoreSettings(
    UpdateWebstoreSettingsRequest updateWebstoreSettingsRequest,
  ) async {
    try {
      final response = await webStoreServices.updateWebstoreSettings(
        updateWebstoreSettingsRequest,
      );
      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<GetWebstoreSettingsResponse> getWebstoreSettings() async {
    try {
      final response = await webStoreServices.getWebstoreSettings();
      return GetWebstoreSettingsResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<GetStockHeadsWebViewListingResponse>
  getStockHeadsWebViewListing() async {
    try {
      final response = await webStoreServices.getStockHeadsWebViewListing();
      return GetStockHeadsWebViewListingResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<GetDesignWebViewListingResponse> getDesignWebViewListing() async {
    try {
      final response = await webStoreServices.getDesignWebViewListing();
      return GetDesignWebViewListingResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  //2x2 banner api

  Future<BannersFourXFourImagePresignedUrlRequest>
  bannersFourXFourImagePresignedUrl(
    BannersFourXFourImagePresignedUrlRequest request,
  ) async {
    try {
      final response = await webStoreServices.bannersFourXFourImagePresignedUrl(
        request,
      );
      return BannersFourXFourImagePresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting banner presigned URL: $e');
      rethrow;
    }
  }

  Future putBannerFourXFourImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await webStoreServices.putBannerFourXFourImages(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading image to S3: $e');
      rethrow;
    }
  }

  Future<GetAllBannersFourXFourResponse> getAllFourXFourBanners({
    bool? is_webstore,
  }) async {
    try {
      final response = await webStoreServices.getAllFourXFourBanners(
        is_webstore: is_webstore,
      );
      return GetAllBannersFourXFourResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> updateBannerFourXFour(
    List<UpdateBannersFourXFourRequest> bannerRequests,
  ) async {
    try {
      final response = await webStoreServices.updateBannerFourXFour(
        bannerRequests,
      );
      return response;
    } catch (e) {
      log('Error updating banners: $e');
      rethrow;
    }
  }

  //2x2 banner api

  Future<BannersTwoXTwoImagePresignedUrlRequest>
  bannersTwoXTwoImagePresignedUrl(
    BannersTwoXTwoImagePresignedUrlRequest request,
  ) async {
    try {
      final response = await webStoreServices.bannersTwoXTwoImagePresignedUrl(
        request,
      );
      return BannersTwoXTwoImagePresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting banner presigned URL: $e');
      rethrow;
    }
  }

  Future putBannerTwoXTwoImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await webStoreServices.putBannerTwoXTwoImages(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading image to S3: $e');
      rethrow;
    }
  }

  Future<GetAllBannersTwoXTwoResponse> getAllTwoXTwoBanners({
    bool? is_webstore,
  }) async {
    try {
      final response = await webStoreServices.getAllTwoXTwoBanners(
        is_webstore: is_webstore,
      );
      return GetAllBannersTwoXTwoResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> updateBannerTwoXTwo(
    List<UpdateBannersTwoXTwoRequest> bannerRequests,
  ) async {
    try {
      final response = await webStoreServices.updateBannerTwoXTwo(
        bannerRequests,
      );
      return response;
    } catch (e) {
      log('Error updating banners: $e');
      rethrow;
    }
  }

  //1x1 banner api

  Future<BannersOneXOneImagePresignedUrlRequest>
  bannersOneXOneImagePresignedUrl(
    BannersOneXOneImagePresignedUrlRequest request,
  ) async {
    try {
      final response = await webStoreServices.bannersOneXOneImagePresignedUrl(
        request,
      );
      return BannersOneXOneImagePresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting banner presigned URL: $e');
      rethrow;
    }
  }

  Future putBannerOneXOneImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await webStoreServices.putBannerOneXOneImages(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading image to S3: $e');
      rethrow;
    }
  }

  Future<GetAllBannersOneXOneResponse> getAllOneXOneBanners({
    bool? is_webstore,
  }) async {
    try {
      final response = await webStoreServices.getAllOneXOneBanners(
        is_webstore: is_webstore,
      );
      return GetAllBannersOneXOneResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> updateBannerOneXOne(
    List<UpdateBannersOneXOneRequest> bannerRequests,
  ) async {
    try {
      final response = await webStoreServices.updateBannerOneXOne(
        bannerRequests,
      );
      return response;
    } catch (e) {
      log('Error updating banners: $e');
      rethrow;
    }
  }

  //customer feedback

  Future<void> updateCustomerFeedback(
    List<UpdateCustomerFeedbackRequest> updateCollectionRequests,
  ) async {
    try {
      final requestList =
          updateCollectionRequests.map((request) => request.toJson()).toList();

      final response = await webStoreServices.updateCustomerFeedback(
        requestList,
      );
      return response;
    } catch (e) {
      log("Error updating categories: ${e.toString()}");
      rethrow;
    }
  }

  Future<FeedbackPresignedUrlSaveRequest> customerFeedbackImagePresignedUrl(
    FeedbackPresignedUrlSaveRequest request,
  ) async {
    try {
      final response = await webStoreServices.customerFeedbackImagePresignedUrl(
        request,
      );
      return FeedbackPresignedUrlSaveRequest.fromJson(response);
    } catch (e) {
      log('Error getting banner presigned URL: $e');
      rethrow;
    }
  }

  Future putCustomerFeedbackImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await webStoreServices.putCustomerFeedbackImages(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading image to S3: $e');
      rethrow;
    }
  }

  Future<GetAllCustomerFeedbackResponse> getAllCustomerFeedback() async {
    try {
      final response = await webStoreServices.getAllCustomerFeedback();
      return GetAllCustomerFeedbackResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //collection
  Future<void> updateCollection(
    List<UpdateCollectionRequest> updateCollectionRequests,
  ) async {
    try {
      final requestList =
          updateCollectionRequests.map((request) => request.toJson()).toList();

      final response = await webStoreServices.updateCollection(requestList);
      return response;
    } catch (e) {
      log("Error updating categories: ${e.toString()}");
      rethrow;
    }
  }

  Future<CollectionImagesPresignedUrlRequest> collectionImagePresignedUrl(
    CollectionImagesPresignedUrlRequest request,
  ) async {
    try {
      final response = await webStoreServices.collectionImagePresignedUrl(
        request,
      );
      return CollectionImagesPresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting banner presigned URL: $e');
      rethrow;
    }
  }

  Future putCollectionImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await webStoreServices.putCollectionImages(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading image to S3: $e');
      rethrow;
    }
  }

  Future<GetAllCollectionResponse> getAllCollections({
    bool? is_webstore,
  }) async {
    try {
      final response = await webStoreServices.getAllCollections(
        is_webstore: is_webstore,
      );
      return GetAllCollectionResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateCategories(
    List<UpdateCategoryRequest> updateCategoryRequests,
  ) async {
    try {
      final requestList =
          updateCategoryRequests.map((request) => request.toJson()).toList();

      final response = await webStoreServices.updateCategories(requestList);
      return response;
    } catch (e) {
      log("Error updating categories: ${e.toString()}");
      rethrow;
    }
  }

  Future<CategoryImagesPresignedUrlRequest> categoryImagePresignedUrl(
    CategoryImagesPresignedUrlRequest request,
  ) async {
    try {
      final response = await webStoreServices.categoryImagePresignedUrl(
        request,
      );
      return CategoryImagesPresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting banner presigned URL: $e');
      rethrow;
    }
  }

  Future putCategoryImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await webStoreServices.putCategoryImages(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading image to S3: $e');
      rethrow;
    }
  }

  Future<GetAllCategoriesResponse> getAllCategories({bool? is_webstore}) async {
    try {
      final response = await webStoreServices.getAllCategories(
        is_webstore: is_webstore,
      );
      return GetAllCategoriesResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<BannerImagesPresignedUrlRequest> bannerImagePresignedUrl(
    BannerImagesPresignedUrlRequest request,
  ) async {
    try {
      final response = await webStoreServices.bannerImagePresignedUrl(request);
      return BannerImagesPresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting banner presigned URL: $e');
      rethrow;
    }
  }

  Future putBannerImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await webStoreServices.putBannerImages(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading image to S3: $e');
      rethrow;
    }
  }

  Future<GetAllBannersResponse> getAllBanners({bool? is_webstore}) async {
    try {
      final response = await webStoreServices.getAllBanners(
        is_webstore: is_webstore,
      );
      return GetAllBannersResponse.fromJson(response);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> updateBanners(
    List<UpdateBannerRequest> bannerRequests,
  ) async {
    try {
      final response = await webStoreServices.updateBanners(bannerRequests);
      return response;
    } catch (e) {
      log('Error updating banners: $e');
      rethrow;
    }
  }

  Future<dynamic> createBanners(
    List<CreateBannerRequest> bannerRequests,
  ) async {
    try {
      final response = await webStoreServices.createBanners(bannerRequests);
      return response;
    } catch (e) {
      log('Error creating banners: $e');
      rethrow;
    }
  }

  Future<PaginatedGetOrderListingResponse> getOrderListing({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    log("The query will be r $query");
    final response = await webStoreServices.getOrderListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );

    final data = PaginatedGetOrderListingResponse.fromJson(response);
    return data;
  }

  Future<GetSettlementsListingResponse> getWebStoreSettlements({
    String? offsetId,
    int limit = 10,
    String query = '',
    String? dateFrom,
    String? dateTo,
    List<int>? gatewayType,
  }) async {
    log("The query will be r $query");
    final response = await webStoreServices.getWebStoreSettlements(
      offsetId: offsetId,
      limit: limit,
      query: query,
      dateFrom: dateFrom,
      dateTo: dateTo,
      gatewayType: gatewayType,
    );

    // Use the correct model name
    final data = GetSettlementsListingResponse.fromJson(response);
    return data;
  }

  Future<GetSettlementsDetailsListingResponse> getSettlementDetails({
    required String settlementId,
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await webStoreServices.getSettlementDetails(
      settlementId: settlementId,
      offsetId: offsetId,
      limit: limit,
      query: query,
    );

    final data = GetSettlementsDetailsListingResponse.fromJson(response);
    return data;
  }

  Future<WebStoreOrderDetailByIdResponse> getWebStoreOrderDetail(
    String orderId,
  ) async {
    final response = await webStoreServices.getWebStoreOrderDetail(orderId);
    return WebStoreOrderDetailByIdResponse.fromMap(response);
  }

  Future<bool> onWebStoreStatusChange(String orderItemId, Map data) async {
    final response = await webStoreServices.onWebStoreStatusChange(
      orderItemId,
      data,
    );
    return response;
  }

  Future<CatalogImagesPresignedUrlRequest> shippingStatusImagePresignedUrl(
    CatalogImagesPresignedUrlRequest request,
  ) async {
    try {
      final response = await webStoreServices.shippingStatusImagePresignedUrl(
        request,
      );
      return CatalogImagesPresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting shipped presigned URL: $e');
      rethrow;
    }
  }

  Future putShippingImages({
    required String putUrl,
    required String imagePath,
  }) async {
    final response = await webStoreServices.putShippingImages(
      putUrl: putUrl,
      imagePath: imagePath,
    );
    return response;
  }
}
