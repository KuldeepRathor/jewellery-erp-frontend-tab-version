import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_advance_booking_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/advance_booking/sales_advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class SalesAdvanceBookingDialog extends StatefulWidget {
  const SalesAdvanceBookingDialog({super.key});

  @override
  State<SalesAdvanceBookingDialog> createState() =>
      _SalesAdvanceBookingDialogState();
}

class _SalesAdvanceBookingDialogState extends State<SalesAdvanceBookingDialog> {
  final SalesAdvanceBookingController controller =
      Get.find<SalesAdvanceBookingController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const SaveAdvanceBookingIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              SaveAdvanceBookingIntent:
                  CallbackAction<SaveAdvanceBookingIntent>(
                    onInvoke: (SaveAdvanceBookingIntent intent) {
                      controller.submitBooking();
                      return null;
                    },
                  ),
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildBody()),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Add Advance Bookings',
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () {
              Get.back();
              controller.clearControllers();
            },
            icon: const Icon(Icons.close, color: Colors.red, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSearchSection(),
            const SizedBox(height: 24),
            _buildFetchedBookingDetails(),
            const SizedBox(height: 24),
            _buildSelectedBookings(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Search Booking",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                autofocus: true,
                controller: controller.bookingDetailsController,
                name: 'Booking ID',
                validator: (value) {
                  if (controller.selectedAdvanceBookings.isEmpty) {
                    return 'Please add at least one booking';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  width: 120,
                  child: Obx(
                    () => CustomButton1(
                      buttonName: 'Fetch Details',
                      isLoading: controller.isFetchingDetails.value,
                      onTap: controller.fetchCustomerDetails,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFetchedBookingDetails() {
    return Obx(
      () => Visibility(
        visible:
            controller.getAdvanceBookingResponse.value.status ==
            Status.COMPLETED,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomDashedLineWidget(width: double.infinity),
            const SizedBox(height: 24),
            const CustomText(
              text: "Fetched Booking Details",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 16),
            Obx(
              () => _buildBookingDetailsCard(
                controller.getAdvanceBookingResponse.value,
                showAddButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const CustomDashedLineWidget(width: double.infinity),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedBookings() {
    return Obx(
      () => Visibility(
        visible: controller.selectedAdvanceBookings.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Selected Bookings",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text:
                        "Total Advance: ₹${controller.totalAdvancePaid.value.toStringAsFixed(2)}",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children:
                  controller.selectedAdvanceBookings.map((booking) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSelectedBookingCard(booking),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedBookingCard(AdvanceBookingResult booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildBookingDetailsRow(booking)),
          // CustomInkButton(
          //   width: 120,
          //   onPressed: () async {
          //     await controller.showCustomReusableOtpDialog(booking: booking);
          //   },
          //   text: "Send OTP",
          //   backgroundColor: Colors.transparent,
          //   textColor: primaryColor,
          //   focusColor: Colors.blue.withOpacity(0.3),
          // ),
          IconButton(
            onPressed: () => controller.removeAdvanceBooking(booking),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsRow(AdvanceBookingResult booking) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailColumn('Booking ID', booking.bookingId ?? ''),
        _buildDetailColumn('Booking Rate/gms', '${booking.rateValue}'),
        _buildDetailColumn('Weight (gms)', '${booking.quantity}'),
        _buildDetailColumn('Advance Paid', '₹${booking.cost ?? 0}'),
        _buildDetailColumn('Status', '${booking.status}'),
      ],
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 4),
          CustomText(text: value, fontSize: 15, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard(
    ApiResponse<GetAdvanceBookingResponse> response, {
    bool showAddButton = false,
  }) {
    switch (response.status) {
      case Status.LOADING:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        );

      case Status.ERROR:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  response.message ?? 'Error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

      case Status.COMPLETED:
        final booking = response.data?.results?.first;
        if (booking == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildBookingDetailsRow(booking)),
              if (showAddButton)
                CustomInkButton(
                  width: 120,
                  onPressed: () {
                    controller.addAdvanceBooking();
                  },
                  text: "+ Add",
                  backgroundColor: Colors.transparent,
                  textColor: primaryColor,
                  focusColor: Colors.blue.withOpacity(0.3),
                ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 140,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.submitBooking();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Obx(
                () =>
                    controller.isLoading.value
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                            strokeWidth: 2,
                          ),
                        )
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Done",
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              text: " (ctrl + s)",
                              color: whiteColor,
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
