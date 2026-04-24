import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/create_customer_aadhar_presigned_url_save_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/create_customer_pan_presigned_url_save_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_country_code_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_by_id_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/verify_aadhar_otp_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/verify_pan_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/verify_pan_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/otp_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_listing/view_model/customer_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/gst_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/customer_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:toastification/toastification.dart';
import 'package:path/path.dart' as path;

class CustomerController extends GetxController {
  // static const String baseUrl = "http://localhost:3000";
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  final CustomerRepository addCustomerRepository = CustomerRepository();
  final VendorRepository addVendorRepository = VendorRepository();
  final OrganizationRepository organizationRepository =
      OrganizationRepository();
  final formKey = GlobalKey<FormState>();
  // final gstFieldKey = GlobalKey<FormState>();

  //Text editing controllers
  final phoneNumberController = TextEditingController();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  final pinCodeController = TextEditingController();
  final panController = TextEditingController();
  final gstController = TextEditingController();

  final aadharController = TextEditingController();
  final genderController = TextEditingController();

  final Rx<File?> panCardFile = Rx<File?>(null);
  final Rx<File?> aadharCardFile = Rx<File?>(null);
  final RxString panCardFileName = ''.obs;
  final RxString aadharCardFileName = ''.obs;
  final RxBool isPanUploading = false.obs;
  final RxBool isAadharUploading = false.obs;

  final RxList<AadharPanImage> uploadedPanImages = <AadharPanImage>[].obs;
  final RxList<AadharPanImage> uploadedAadharImages = <AadharPanImage>[].obs;

  bool get hasPendingPanUpload =>
      panCardFile.value != null && uploadedPanImages.isEmpty;

  bool get hasPendingAadharUpload =>
      aadharCardFile.value != null && uploadedAadharImages.isEmpty;

  final RxList<GetCountryCodeResponse> countryCodes =
      <GetCountryCodeResponse>[].obs;
  final Rx<GetCountryCodeResponse?> selectedCountryCode =
      Rx<GetCountryCodeResponse?>(null);
  final countryCodeFocusNode = FocusNode();

  // Observable variables for UI state
  final isLoading = false.obs;
  final detailsFetched = false.obs;

  final fetchedGstType = ''.obs;

  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;
  final RxBool isCheckingPinCode = false.obs;
  final RxBool isPinCodeValid = true.obs;

  final RxBool isGSTAvailable = true.obs;
  final RxBool isCheckingGST = false.obs;

  final RxBool isPhoneAvailable = true.obs;
  final RxBool isCheckingPhone = false.obs;

  final FocusNode panFocusNode = FocusNode();

  String? currentCustomerId;

  String? panVerificationId;
  String? aadhaarVerificationId;

  final RxBool isPanVerifiedOffline = false.obs;
  final RxBool isPanVerifiedOnline = false.obs;
  final RxBool isAadhaarVerifiedOffline = false.obs;
  final RxBool isAadhaarVerifiedOnline = false.obs;

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final isLoadingCountryCodes = true.obs;
  // final phoneNumber = ''.obs;
  // final name = ''.obs;
  // final addressLine1 = ''.obs;
  // final addressLine2 = ''.obs;
  // final city = ''.obs;
  // final pinCode = ''.obs;
  // final panNumber = ''.obs;
  // final gstNumber = ''.obs;

  // final isLoading = false.obs;
  // final isPanVerified = false.obs;
  // final gstType = ''.obs;
  final isPANVerified = false.obs;
  final isPANValid = false.obs;

  bool isValidPAN(String pan) {
    RegExp panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return panPattern.hasMatch(pan);
  }

  final panVerificationResponse = Rx<ApiResponse<VerifyPanResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Future<void> verifyPAN() async {
  //   String pan = panController.text.toUpperCase();
  //   panVerificationResponse.value = ApiResponse.loading("Verifying PAN...");

  //   try {
  //     // Simulating an API call for PAN verification
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     bool isValid = isValidPAN(pan);

  //     panVerificationResponse.value = ApiResponse.completed(isValid);
  //     isPANValid.value = isValid;
  //     isPANVerified.value = true;

  //     if (isValid) {
  //       showSuccessToast(message: "PAN number is valid");
  //     } else {
  //       // showErrorToast(message: "Invalid PAN number");
  //     }
  //   } catch (e) {
  //     panVerificationResponse.value =
  //         ApiResponse.error("PAN verification failed");
  //     // showErrorToast(message: "PAN verification failed");
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    fetchLedgerItems();
    getCountryCodes();
  }

  void removePanCard() {
    panCardFile.value = null;
    panCardFileName.value = '';
    showSuccessToast(message: "PAN card removed");
  }

  void removeAadharCard() {
    aadharCardFile.value = null;
    aadharCardFileName.value = '';
    showSuccessToast(message: "Aadhar card removed");
  }

  @override
  void onClose() {
    // Clean up
    panCardFile.value = null;
    aadharCardFile.value = null;
    super.onClose();
  }

  Future<void> pickPanCard() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        panCardFile.value = File(result.files.single.path!);
        panCardFileName.value = result.files.single.name;

        // Validate file size (e.g., max 5MB)
        final fileSize = await panCardFile.value!.length();
        if (fileSize > 5 * 1024 * 1024) {
          showErrorToast(message: "File size should not exceed 5MB");
          panCardFile.value = null;
          panCardFileName.value = '';
          return;
        }

        showSuccessToast(
          message: "PAN card selected: ${result.files.single.name}",
        );
      }
    } catch (e) {
      log('Error picking PAN card: $e');
      showErrorToast(message: "Failed to pick file");
    }
  }

  Future<void> pickAadharCard() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        aadharCardFile.value = File(result.files.single.path!);
        aadharCardFileName.value = result.files.single.name;

        // Validate file size (e.g., max 5MB)
        final fileSize = await aadharCardFile.value!.length();
        if (fileSize > 5 * 1024 * 1024) {
          showErrorToast(message: "File size should not exceed 5MB");
          aadharCardFile.value = null;
          aadharCardFileName.value = '';
          return;
        }

        showSuccessToast(
          message: "Aadhar card selected: ${result.files.single.name}",
        );
      }
    } catch (e) {
      log('Error picking Aadhar card: $e');
      showErrorToast(message: "Failed to pick file");
    }
  }

  Future<void> uploadPanCard() async {
    if (panCardFile.value == null) {
      showErrorToast(message: "Please select a PAN card file first");
      return;
    }

    if (panController.text.isEmpty) {
      showErrorToast(message: "Please enter PAN number first");
      return;
    }

    try {
      isPanUploading.value = true;
      log("Starting PAN card upload");

      // Get file name and extension
      final fileName = path.basename(panCardFile.value!.path);
      final fileType = path.extension(fileName).replaceFirst(".", "");

      // Create request for presigned URL
      final presignedUrlRequest = CustomerPanPresignedUrlSave(
        groupId: currentCustomerId, // Use customer ID if editing, null for new
        images: [
          CustomerPanPresignedUrlSaveImage(
            fileName: fileName,
            fileType: fileType,
          ),
        ],
      );

      // Get the presigned URL
      final presignedUrlResponse = await addCustomerRepository
          .customerPanPresignedUrl(presignedUrlRequest);

      if (presignedUrlResponse.images != null &&
          presignedUrlResponse.images!.isNotEmpty &&
          presignedUrlResponse.images!.first.presignedUrl != null) {
        final putUrl = presignedUrlResponse.images!.first.presignedUrl!;
        final s3Key = presignedUrlResponse.images!.first.s3Key;
        final imageId = presignedUrlResponse.images!.first.id;

        // Upload the image to S3 using the presigned URL
        await addCustomerRepository.putCustomerPanImage(
          putUrl: putUrl,
          imagePath: panCardFile.value!.path,
        );

        // Store the uploaded image reference
        final uploadedImage = AadharPanImage(
          id: imageId,
          fileName: fileName,
          fileType: fileType,
          s3Key: s3Key,
          presignedUrl: putUrl,
        );

        uploadedPanImages.clear();
        uploadedPanImages.add(uploadedImage);

        isPanVerifiedOffline.value = true;
        showSuccessToast(message: "PAN card uploaded successfully");

        log("PAN card uploaded successfully");
      } else {
        throw Exception("Failed to get presigned URL for PAN card upload");
      }
    } catch (e) {
      log('Error uploading PAN card: $e');
      showErrorToast(message: "Failed to upload PAN card: ${e.toString()}");
    } finally {
      isPanUploading.value = false;
    }
  }

  Future<void> uploadAadharCard() async {
    if (aadharCardFile.value == null) {
      showErrorToast(message: "Please select an Aadhar card file first");
      return;
    }

    if (aadharController.text.isEmpty) {
      showErrorToast(message: "Please enter Aadhar number first");
      return;
    }

    try {
      isAadharUploading.value = true;
      log("Starting Aadhar card upload");

      // Get file name and extension
      final fileName = path.basename(aadharCardFile.value!.path);
      final fileType = path.extension(fileName).replaceFirst(".", "");

      // Create request for presigned URL
      final presignedUrlRequest = CustomerAadharPresignedUrlSave(
        groupId: currentCustomerId, // Use customer ID if editing, null for new
        images: [
          CustomerAadharPresignedUrlSaveImage(
            fileName: fileName,
            fileType: fileType,
          ),
        ],
      );

      // Get the presigned URL
      final presignedUrlResponse = await addCustomerRepository
          .customerAadharPresignedUrl(presignedUrlRequest);

      if (presignedUrlResponse.images != null &&
          presignedUrlResponse.images!.isNotEmpty &&
          presignedUrlResponse.images!.first.presignedUrl != null) {
        final putUrl = presignedUrlResponse.images!.first.presignedUrl!;
        final s3Key = presignedUrlResponse.images!.first.s3Key;
        final imageId = presignedUrlResponse.images!.first.id;

        // Upload the image to S3 using the presigned URL
        await addCustomerRepository.putCustomerAadharImage(
          putUrl: putUrl,
          imagePath: aadharCardFile.value!.path,
        );

        // Store the uploaded image reference
        final uploadedImage = AadharPanImage(
          id: imageId,
          fileName: fileName,
          fileType: fileType,
          s3Key: s3Key,
          presignedUrl: putUrl,
        );

        uploadedAadharImages.clear();
        uploadedAadharImages.add(uploadedImage);

        isAadhaarVerifiedOffline.value = true;
        showSuccessToast(message: "Aadhar card uploaded successfully");

        log("Aadhar card uploaded successfully");
      } else {
        throw Exception("Failed to get presigned URL for Aadhar card upload");
      }
    } catch (e) {
      log('Error uploading Aadhar card: $e');
      showErrorToast(message: "Failed to upload Aadhar card: ${e.toString()}");
    } finally {
      isAadharUploading.value = false;
    }
  }

  Future<void> getCountryCodes({String query = ''}) async {
    try {
      isLoadingCountryCodes.value = true;
      final response = await addCustomerRepository.getCountryCode(query: query);
      // Sort alphabetically by country name
      response.sort((a, b) => a.name?.compareTo(b.name ?? '') ?? 0);
      countryCodes.value = response;

      // Set default value if not already set
      if (selectedCountryCode.value == null) {
        final defaultCode = response.firstWhere(
          (code) => code.name == "IN",
          orElse: () => GetCountryCodeResponse(name: "IN", code: "+91"),
        );
        selectedCountryCode.value = defaultCode;
      }
    } catch (e, stack) {
      log('Error fetching country codes: $e $stack');
      showErrorToast(message: "Failed to fetch country codes");
    } finally {
      isLoadingCountryCodes.value = false;
    }
  }

  void setSelectedCountryCode(GetCountryCodeResponse value) {
    selectedCountryCode.value = value;
    log('Selected country code: ${value.name} (${value.code})');
  }

  void checkGSTAvailability(String gst) {
    if (gst.isEmpty) {
      isGSTAvailable.value = true;
      isCheckingGST.value = false;
      return;
    }

    isCheckingGST.value = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await addCustomerRepository
            .gst_phone_number_availability(gst, 'gst');
        isGSTAvailable.value = isAvailable;
      } catch (e, stack) {
        log('Error checking GST availability: $e, $stack');
        showErrorToast(message: "Failed to check GST availability");
      } finally {
        isCheckingGST.value = false;
      }
    });
  }

  void checkPhoneAvailability(String phone) {
    if (phone.isEmpty) {
      isPhoneAvailable.value = true;
      isCheckingPhone.value = false;
      return;
    }

    isCheckingPhone.value = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await addCustomerRepository
            .gst_phone_number_availability(phone, 'phone number');
        isPhoneAvailable.value = isAvailable;
      } catch (e, stack) {
        log('Error checking phone availability: $e, $stack');
        showErrorToast(message: "Failed to check phone number availability");
      } finally {
        isCheckingPhone.value = false;
      }
    });
  }

  Future<void> verifyPAN() async {
    try {
      if (nameController.text.isEmpty) {
        showErrorToast(message: "Please enter Name first");
        return;
      }

      String pan = panController.text.toUpperCase();
      panVerificationResponse.value = ApiResponse.loading("Verifying PAN...");

      // First validate PAN format
      if (!isValidPAN(pan)) {
        panVerificationResponse.value = ApiResponse.error("Invalid PAN format");
        isPANValid.value = false;
        isPANVerified.value = true;
        showErrorToast(message: "Invalid PAN format");
        return;
      }

      // Pass customerId if editing existing customer
      final response = await organizationRepository.verifyPanNo(
        pan,
        nameController.text,
        customerId: currentCustomerId,
      );

      panVerificationResponse.value = ApiResponse.completed(response);

      // Check if PAN is verified based on the new response structure
      final isValid =
          response.isPanVerified == true &&
          response.panStatus?.toLowerCase() == 'valid';

      isPANValid.value = isValid;
      isPANVerified.value = true;

      if (isValid) {
        // Store the PAN verification ID when verification is successful
        panVerificationId = response.id;
        showSuccessToast(
          message: response.message ?? "PAN verified successfully",
        );
      } else {
        // Clear the verification ID if verification fails
        panVerificationId = null;
        showErrorToast(message: response.message ?? "PAN verification failed");
      }
    } catch (e) {
      log('Error verifying PAN: $e');
      panVerificationResponse.value = ApiResponse.error(
        "PAN verification failed",
      );
      isPANValid.value = false;
      isPANVerified.value = true;
      panVerificationId = null; // Clear on error
      showErrorToast(message: "$e");
    }
  }
  // String? validatePAN(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'PAN number is required';
  //   }
  //   if (!isValidPAN(value)) {
  //     return 'Invalid PAN number format';
  //   }
  //   return null;
  // }

  void checkCodeAvailability(String code) {
    if (code.isEmpty) {
      isCodeAvailable.value = true;
      isCheckingCode.value = false;
      return;
    }

    isCheckingCode.value = true;
    _debouncer.run(() async {
      // Simulating API call
      try {
        final isAvailable = await addVendorRepository.validateCode(code);
        isCodeAvailable.value = isAvailable;
      } catch (e, stack) {
        log('Error checking code availability: $e, $stack');
        // Get.snackbar('Error', 'Failed to check code availability');
        showErrorToast(message: "Failed to check code availability");
      } finally {
        isCheckingCode.value = false;
      }
    });
  }

  void checkPinCodeAndSetCity(String pinCode) {
    if (pinCode.length != 6) {
      isPinCodeValid.value = false;
      cityController.text = '';
      stateController.text = '';
      return;
    }

    isCheckingPinCode.value = true;
    _debouncer.run(() async {
      try {
        final pincodeResponse = await addVendorRepository.getCityFromPincode(
          pinCode,
        );
        if (pincodeResponse != null) {
          cityController.text = pincodeResponse.city ?? '';
          stateController.text = pincodeResponse.state ?? '';
          isPinCodeValid.value = true;

          panFocusNode.requestFocus();
        } else {
          cityController.text = '';
          stateController.text = '';
          isPinCodeValid.value = false;
        }
      } catch (e) {
        log('Error checking pincode: $e');
        showErrorToast(message: "Failed to validate pincode");
        isPinCodeValid.value = false;
        cityController.text = '';
        stateController.text = '';
      } finally {
        isCheckingPinCode.value = false;
      }
    });
  }

  bool validateGST(String gst) {
    return gst.isNotEmpty && gst.length == 15;
  }

  String? validateGSTField(String? value) {
    if (selectedDeduction.value != 'None') {
      if (value == null || value.isEmpty) {
        return 'GST number is required for TCS/TDS';
      }
      if (!validateGST(value)) {
        return 'Invalid GST number format';
      }
      if (!isGSTAvailable.value) {
        return 'This GST number is already registered';
      }
      if (gstDetailsResponse.value.status != Status.COMPLETED) {
        return 'GST verification required for TCS/TDS';
      }
    }
    return null;
  }

  final gstDetailsResponse = Rx<ApiResponse<GstDetailsResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> fetchGSTDetails() async {
    final gstNumber = gstController.text.trim();

    // if (!validateGST(gstNumber)) {
    //   gstDetailsResponse.value = ApiResponse.error("Invalid GST number");
    //   return;
    // }
    gstDetailsResponse.value = ApiResponse.initial("Initial");

    if (!validateGST(gstNumber)) {
      gstDetailsResponse.value = ApiResponse.error("Invalid GST number");
      return;
    }
    gstDetailsResponse.value = ApiResponse.loading("Loading..");

    try {
      final response = await addVendorRepository.fetchGSTDetails(gstNumber);
      gstDetailsResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "GST details fetched successfully");
    } catch (e) {
      log("Fetch GST Details error: ${e.toString()}");
      gstDetailsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch GST details");
    }
  }

  final aadharVerificationResponse = Rx<ApiResponse<VerifyAadharOtpResponse>>(
    ApiResponse.initial("Initial"),
  );
  final isAadharVerified = false.obs;
  String? verificationRefId;
  Future<void> verifyAadhar() async {
    try {
      if (aadharController.text.length != 12) {
        showErrorToast(message: "Please enter valid 12-digit Aadhar number");
        return;
      }

      aadharVerificationResponse.value = ApiResponse.loading(
        "Verifying Aadhar...",
      );

      verificationRefId = await organizationRepository.getAadharOtp(
        adhar_number: aadharController.text,
      );

      // Show the CustomOtpDialog
      // ignore: unused_local_variable
      final result = await Get.dialog<bool>(
        CustomOtpDialog(
          title: 'Aadhar Verification',
          message:
              'OTP has been sent to your registered mobile number linked with Aadhar',
          identifier: aadharController.text,
          otpLength: 6,
          isLoading: aadharVerificationResponse.value.status == Status.LOADING,
          onVerify: (otp) async {
            try {
              aadharVerificationResponse.value = ApiResponse.loading(
                "Verifying OTP...",
              );

              // Pass customerId only when editing existing customer
              final response = await organizationRepository.verifyAadharOtp(
                ref_id: verificationRefId!,
                otp: otp,
                aadhaarNumber: aadharController.text,
                customerId: currentCustomerId, // Will be null for new customers
              );

              log('Aadhar verification response: ${response.toJson()}');

              // Check the top-level status or the nested aadhaar_data status
              final isVerified =
                  (response.aadhaarStatus?.toUpperCase() == "VALID" ||
                      response.status?.toUpperCase() == "VALID") &&
                  (response.attemptStatus?.toUpperCase() == "SUCCESS");

              if (isVerified) {
                // Store the verification ID
                aadhaarVerificationId = response.id;

                // Use the helper getters which access aadhaarData
                nameController.text = response.name ?? '';
                genderController.text =
                    response.gender == 'M' ? 'Male' : 'Female';
                dobController.text = response.dob ?? '';

                if (response.splitAddress != null) {
                  address1Controller.text = response.splitAddress?.house ?? '';
                  address2Controller.text = response.splitAddress?.street ?? '';
                  cityController.text = response.splitAddress?.dist ?? '';
                  stateController.text = response.splitAddress?.state ?? '';
                  pinCodeController.text = response.splitAddress?.pincode ?? '';
                }

                isAadharVerified.value = true;
                aadharVerificationResponse.value = ApiResponse.completed(
                  response,
                );
                Get.back(result: true);
                showSuccessToast(
                  message: response.message ?? "Aadhar verified successfully",
                );
              } else {
                aadharVerificationResponse.value = ApiResponse.error(
                  "Invalid OTP",
                );
                showErrorToast(message: response.message ?? "Invalid OTP");
              }
            } catch (e) {
              log('Error verifying OTP: $e');
              aadharVerificationResponse.value = ApiResponse.error(
                e.toString(),
              );
              showErrorToast(message: "Failed to verify OTP");
            }
          },
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      log('Error verifying Aadhar: $e');
      aadharVerificationResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to verify Aadhar");
    }
  }

  String? validateAadhar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhar number is required';
    }
    if (value.length != 12) {
      return 'Aadhar number must be 12 digits';
    }
    if (!isAadharVerified.value) {
      return 'Aadhar verification required';
    }
    return null;
  }
  // void submitForm() {
  //   if (formKey.currentState!.validate()) {
  //     // Process the form data
  //     log('Form is valid. Submitting the data.');
  //     // Add your logic here to submit the form data
  //   }
  // }

  // void validateForm() {
  //   formKey.currentState!.validate();
  // }
  String formatDateOfBirth(String date) {
    try {
      DateFormat inputFormat;
      if (date.contains('/')) {
        inputFormat = DateFormat('d/M/yyyy'); // Handle 30/1/2025
      } else {
        inputFormat = DateFormat('d-M-yyyy'); // Handle 30-1-2025
      }
      final outputFormat = DateFormat('yyyy-MM-dd');
      final DateTime parsedDate = inputFormat.parse(date);
      return outputFormat.format(parsedDate);
    } catch (e) {
      log('Error formatting date: $e');
      return date; // Return as is to prevent crashes
    }
  }

  final addCustomerResponse = Rx<ApiResponse<CustomerDetails>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> submitCustomerDetails(String? customerId) async {
    try {
      if (formKey.currentState!.validate() == false) {
        showErrorToast(message: "Please check the data");
        return;
      }
      if (selectedDeduction.value != 'None') {
        if (!isPANValid.value) {
          showErrorToast(message: "Please verify PAN number");
          return;
        }
        // if (gstDetailsResponse.value.status != Status.COMPLETED) {
        //   showErrorToast(message: "Please verify GST number");
        //   return;
        // }
        if (percentageController.text.isEmpty) {
          showErrorToast(message: "Please enter deduction percentage");
          return;
        }
      }
      addCustomerResponse.value = ApiResponse.loading("Loading");

      try {
        // Upload PAN card if selected but not uploaded
        if (hasPendingPanUpload) {
          log("Auto-uploading PAN card before submit...");
          await uploadPanCard();

          // Check if upload was successful
          if (uploadedPanImages.isEmpty) {
            throw Exception("PAN card upload failed");
          }
        }

        // Upload Aadhar card if selected but not uploaded
        if (hasPendingAadharUpload) {
          log("Auto-uploading Aadhar card before submit...");
          await uploadAadharCard();

          // Check if upload was successful
          if (uploadedAadharImages.isEmpty) {
            throw Exception("Aadhar card upload failed");
          }
        }
      } catch (e) {
        log('Error uploading documents: $e');
        addCustomerResponse.value = ApiResponse.error(
          "Failed to upload documents",
        );
        showErrorToast(message: "Failed to upload documents: ${e.toString()}");
        return;
      }
      final CustomerDetails customerDataRequest = CustomerDetails(
        name: nameController.text,
        phoneCountryCode: selectedCountryCode.value?.code ?? "+91",
        phoneNumber: phoneNumberController.text,
        deductionPercent:
            (percentageController.text.trim().isEmpty)
                ? "0"
                : percentageController.text.trim(),
        deductionType:
            selectedDeduction.value.toLowerCase() == 'none'
                ? null
                : selectedDeduction.value,
        ledgerId: selectedLedger.value?.id,

        // panVerificationId: panVerificationId,
        // aadhaarVerificationId: aadhaarVerificationId,
        address: [
          Address(
            phoneCountryCode: selectedCountryCode.value?.code ?? "+91",
            addressLine1: address1Controller.text,
            addressLine2: address2Controller.text,
            city: cityController.text,
            pincode: pinCodeController.text,
            state: stateController.text,
            type: "customer",
            isDefault: true,
            isJlAddress: false,
            phoneNumber: phoneNumberController.text,
          ),
        ],
        panNumber: panController.text,
        aadhaarNumber: aadharController.text,
        gstNumber: gstController.text,
        dateOfBirth: DateTime.tryParse(formatDateOfBirth(dobController.text)),
        gender: genderController.text,
        panImages:
            uploadedPanImages.isNotEmpty ? uploadedPanImages.toList() : null,
        aadhaarImages:
            uploadedAadharImages.isNotEmpty
                ? uploadedAadharImages.toList()
                : null,
        panVerificationId: panVerificationId,
        aadhaarVerificationId: aadhaarVerificationId,
      );
      final CustomerDetails response;

      if (customerId == null) {
        response = await addCustomerRepository.addCustomer(customerDataRequest);
      } else {
        response = await addCustomerRepository.putCustomer(
          customerId,
          customerDataRequest,
        );
      }
      addCustomerResponse.value = ApiResponse.completed(response);
      final CustomerSearchValue customerSearchValue = CustomerSearchValue(
        id: response.id,
        name: response.name,
        phoneNumber: response.phoneNumber,
        dateOfBirth: response.dateOfBirth,
        panNumber: response.panNumber,
        gstNumber: response.gstNumber,
        addressUuid: response.addressUuid,
        address:
            response.address
                ?.map(
                  (addr) => Address(
                    phoneCountryCode: addr.phoneCountryCode ?? "+91",
                    city: addr.city,
                    pincode: addr.pincode,
                    addressLine1: addr.addressLine1,
                    addressLine2: addr.addressLine2,
                    state: addr.state,
                  ),
                )
                .toList() ??
            [],
        gender: response.gender,
      );

      final PartyDetailsController partyDetailsController =
          Get.put<PartyDetailsController>(PartyDetailsController());
      partyDetailsController.updateWithNewCustomer(customerSearchValue);
      final CustomerListingViewmodel customerListingViewmodel =
          Get.put<CustomerListingViewmodel>(CustomerListingViewmodel());

      if (Get.isRegistered<EstimationSearchPartyController>()) {
        final controller = Get.find<EstimationSearchPartyController>();
        controller.updateWithNewCustomer(customerSearchValue);
      }

      if (Get.isRegistered<CreateSalesEstimationSearchPartyController>()) {
        final controller =
            Get.find<CreateSalesEstimationSearchPartyController>();
        controller.updateWithNewCustomer(customerSearchValue);
        controller.setSelectedContact(customerSearchValue);
      }
      customerListingViewmodel.getCustomerListingDetails(resetList: true);

      Get.back(result: customerSearchValue);
      Get.back();
      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: Text(
          customerId == null
              ? 'Customer added successfully'
              : "Customer updated successfully",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        alignment: Alignment.bottomCenter,
        icon: const Icon(Icons.check, color: Colors.white),
        primaryColor: Colors.green,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: BorderRadius.circular(100),
      );
    } catch (e, s) {
      log('Error adding customer: $e $s');
      showErrorToast(message: "Failed to add customer");
      // Get.snackbar('Error', 'Failed to add customer');
      addCustomerResponse.value = ApiResponse.error(e.toString());
    }
  }

  final getCustomerResponseById = Rx<ApiResponse<GetCustomerByIdResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Future<void> getCustomer(String query) async {
  //   try {
  //     getCustomerResponse.value = ApiResponse.loading("Loading");
  //     await Future.delayed(const Duration(seconds: 1));
  //     final response = await addCustomerRepository.getCustomer(query);

  //     if (response.values != null && response.values!.isNotEmpty) {
  //       final customerData = response.values![0];
  //       setCustomerData(customerData);
  //       getCustomerResponse.value = ApiResponse.completed(customerData);
  //     } else {
  //       getCustomerResponse.value = ApiResponse.error("No customer data found");
  //     }
  //   } catch (e, stack) {
  //     log('Error getting customer: $e $stack');
  //     getCustomerResponse.value = ApiResponse.error(e.toString());
  //     Get.snackbar("Error", "Failed to load customer");
  //   }
  // }
  Future<void> getCustomerById(String customerId) async {
    try {
      getCustomerResponseById.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await addCustomerRepository.getCustomer(customerId);

      setCustomerData(response);
      getCustomerResponseById.value = ApiResponse.completed(response);
    } catch (e, stack) {
      log('Error getting customer: $e $stack');
      getCustomerResponseById.value = ApiResponse.error(e.toString());
      // Get.snackbar("Error", "Failed to load customer");
      showErrorToast(message: "Failed to load customer");
    }
  }

  void setCustomerData(GetCustomerByIdResponse customerData) {
    phoneNumberController.text = customerData.phoneNumber ?? "";
    nameController.text = customerData.name ?? "";
    dobController.text =
        customerData.dateOfBirth?.toString().split(' ')[0] ?? "";
    percentageController.text = customerData.deductionPercent ?? "";
    selectedDeduction.value = customerData.deductionType ?? "None";
    if (customerData.ledger != null) {
      selectedLedger.value = customerData.ledger;
    }

    // Handle address data from the address list
    if (customerData.address != null && customerData.address!.isNotEmpty) {
      // Get the first address from the list
      Address firstAddress = customerData.address![0];
      if (firstAddress.phoneCountryCode != null) {
        final code = countryCodes.firstWhere(
          (code) => code.code == firstAddress.phoneCountryCode,
          orElse: () => GetCountryCodeResponse(name: "IN", code: "+91"),
        );
        selectedCountryCode.value = code;
      }
      // Set address related fields
      address1Controller.text = firstAddress.addressLine1 ?? "";
      address2Controller.text = firstAddress.addressLine2 ?? "";
      cityController.text = firstAddress.city ?? "";
      stateController.text = firstAddress.state ?? "";
      pinCodeController.text = firstAddress.pincode ?? "";
    } else {
      // Clear address fields if no address data is available
      address1Controller.text = "";
      address2Controller.text = "";
      cityController.text = "";
      stateController.text = "";
      pinCodeController.text = "";
    }

    panController.text = customerData.panNumber ?? "";
    gstController.text = customerData.gstNumber ?? "";
    genderController.text = customerData.gender ?? "";
    aadharController.text = customerData.aadhaarNumber ?? "";

    isPanVerifiedOffline.value = customerData.isPanVerified ?? false;
    isPanVerifiedOnline.value = customerData.isPanOnlineVerified ?? false;
    isAadhaarVerifiedOffline.value = customerData.isAadhaarVerified ?? false;
    isAadhaarVerifiedOnline.value =
        customerData.isAadhaarOnlineVerified ?? false;
  }

  // Add new controllers and observables
  final percentageController = TextEditingController();
  final selectedDeduction = 'None'.obs;
  final Rx<AccountMapping?> selectedLedger = Rx<AccountMapping?>(null);

  // Add deduction items list
  final deductionItems = ['TCS', 'TDS', 'None'];

  // Add the ledger response
  final ledgerListResponse = Rx<ApiResponse<GetAccountMappingResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Add ledger fetch method
  Future<void> fetchLedgerItems() async {
    try {
      ledgerListResponse.value = ApiResponse.loading('Loading..');
      final items = await _purchaseRepository.getAccountMappings();
      ledgerListResponse.value = ApiResponse.completed(items);
    } catch (e, stack) {
      log('Error fetching Ledger list: $e $stack');
      ledgerListResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load Ledger types");
    }
  }

  String? validateCountryCode(String? value) {
    if (selectedCountryCode.value == null) {
      return 'Country code is required';
    }
    return null;
  }

  // Add ledger change handler
  void onLedgerChanged(AccountMapping newSelection) {
    selectedLedger.value = newSelection;
  }

  // Add deduction change handler
  void onDeductionChanged(String? newValue) {
    if (newValue != null) {
      selectedDeduction.value = newValue;
      formKey.currentState?.validate();
    }
  }

  void resetFields() {
    phoneNumberController.clear();
    nameController.clear();
    address1Controller.clear();
    address2Controller.clear();
    cityController.clear();
    pinCodeController.clear();
    panController.clear();
    gstController.clear();
    genderController.clear();
    aadharController.clear();
    getCustomerResponseById.value = ApiResponse.initial("Initial");
    percentageController.clear();
    selectedDeduction.value = 'TCS';
    selectedLedger.value = null;
    currentCustomerId = null;
    selectedCountryCode.value = GetCountryCodeResponse(name: "IN", code: "+91");

    isPANValid.value = false;
    isPANVerified.value = false;
    isAadharVerified.value = false;
    panVerificationResponse.value = ApiResponse.initial("Initial");
    aadharVerificationResponse.value = ApiResponse.initial("Initial");

    isPanVerifiedOffline.value = false;
    isPanVerifiedOnline.value = false;
    isAadhaarVerifiedOffline.value = false;
    isAadhaarVerifiedOnline.value = false;

    panVerificationId = null;
    aadhaarVerificationId = null;
    verificationRefId = null;

    panCardFile.value = null;
    aadharCardFile.value = null;
    panCardFileName.value = '';
    aadharCardFileName.value = '';
    uploadedPanImages.clear();
    uploadedAadharImages.clear();
  }

  String? validatePAN(String? value) {
    if (selectedDeduction.value != 'None') {
      if (value == null || value.isEmpty) {
        return 'PAN number is required for TCS/TDS';
      }
      if (!isValidPAN(value)) {
        return 'Invalid PAN number format';
      }
      if (!isPANValid.value) {
        return 'PAN verification required for TCS/TDS';
      }
    }
    return null;
  }

  String? validateDeductionPercentage(String? value) {
    if (selectedDeduction.value != 'None') {
      if (value == null || value.isEmpty) {
        return 'Percentage is required for TCS/TDS';
      }
      final percentage = double.tryParse(value);
      if (percentage == null) {
        return 'Enter a valid percentage';
      }
      if (percentage < 0 || percentage > 100) {
        return 'Percentage must be between 0 and 100';
      }
    }
    return null;
  }

  Widget getVerificationIcon(bool isOnlineVerified, bool isOfflineVerified) {
    if (isOnlineVerified) {
      return const Icon(
        Icons.done_all, // Double check icon
        color: Colors.green,
        size: 20,
      );
    }
    if (isOfflineVerified) {
      return const Icon(
        Icons.check, // Single check icon
        color: Colors.green,
        size: 20,
      );
    }
    return const SizedBox.shrink();
  }
}
