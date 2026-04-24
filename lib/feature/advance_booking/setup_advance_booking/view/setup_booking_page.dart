import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/setup_advance_booking/view_model/setup_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class SetupBookingPage extends StatefulWidget {
  const SetupBookingPage({super.key});

  @override
  State<SetupBookingPage> createState() => _SetupBookingPageState();
}

class _SetupBookingPageState extends State<SetupBookingPage> {
  final SetupBookingController controller = Get.put(SetupBookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        children: [
          CustomHeaderWidget(
            header: 'Setup Advance Booking',
            wantBackButton: true,
            onBackButtonTap: () {
              Get.find<SidebarController>().popBackSelectedWidget();
            },
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildWeightDetails()),
          const SizedBox(height: 20),
          _footerWidget(),
        ],
      ),
    );
  }

  Widget _buildWeightDetails() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Weight Details',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 15),
            Obx(() {
              final response = controller.getAdvanceBookingSetupResponse.value;

              if (response.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              if (response.status == Status.ERROR) {
                return Center(child: Text('Error: ${response.message}'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.formRows.length,
                itemBuilder: (context, index) {
                  return _customFields(index);
                },
              );
            }),
            InkWell(
              onTap: controller.addNewRow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CustomText(
                    text: '+ Add ',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: grey1,
                    ),
                    child: const CustomText(
                      text: 'Enter',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customFields(int index) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: CustomTextField(
                controller: controller.formRows[index].fromController,
                name: "From(gms)",
                nameColor: blackColor,
                width: Get.width * 0.2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: CustomTextField(
                controller: controller.formRows[index].toController,
                name: "To(gms)",
                nameColor: blackColor,
                width: Get.width * 0.2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: CustomTextField(
                controller: controller.formRows[index].advanceController,
                name: "Advance %",
                nameColor: blackColor,
                width: Get.width * 0.2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: CustomTextField(
                controller: controller.formRows[index].redeemController,
                name: "Redeem Duration",
                nameColor: blackColor,
                width: Get.width * 0.2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: IconButton(
                onPressed: () => controller.removeRow(index),
                icon: const Icon(Icons.delete, color: redTextColor),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: CustomDashedLineWidget(width: Get.width),
        ),
      ],
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: whiteColor,
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.dialog(const AddRemarkDialog()),
            child: Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, color: primaryColor),
                  SizedBox(width: 5),
                  CustomText(
                    text: "Remarks",
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: CustomText(
                  text: "Discard",
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: Get.width * 0.01),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: controller.saveSetup,
              child: Ink(
                height: 38,
                width: 140,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Save",
                      fontSize: 16,
                      color: whiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: CustomText(
                        text: "Ctrl + S",
                        fontSize: 12,
                        color: whiteColor,
                        fontWeight: FontWeight.w700,
                      ),
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
