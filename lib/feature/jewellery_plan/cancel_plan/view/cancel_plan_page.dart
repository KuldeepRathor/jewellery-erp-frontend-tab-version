import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/cancel_plan/view_model/cancel_plan_controllerl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg_flutter.dart';

class CancelPlanPage extends StatefulWidget {
  const CancelPlanPage({super.key});

  @override
  State<CancelPlanPage> createState() => _CancelPlanPageState();
}

class _CancelPlanPageState extends State<CancelPlanPage> {
  // final controller =
  //     Get.put<CustomerListingViewmodel>(CustomerListingViewmodel());
  final CancelPlanController controller = Get.put(CancelPlanController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getJewelleryPlanDetails(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final controllerCreation =
    //     Get.create<CustomerListingViewmodel>(() => CustomerListingViewmodel());
    // final controller = Get.find<CustomerListingViewmodel>();

    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              header: 'Cancel Plan',
              wantBackButton: true,
              onBackButtonTap: () {
                SidebarController sidebarController = Get.find();
                sidebarController.popBackSelectedWidget();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPlanDetails(context),
                    const SizedBox(height: 16),
                    _payment_detals_widget(context),
                    // _buildActionBar(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            FooterWidget(),
          ],
        ),
      ),
    );
  }

  Row _payment_detals_widget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            // height: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'Payment Details',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Plan Type Dropdown
                      const SizedBox(width: 16),
                      CustomTextField(
                        name: 'Amount Collected',
                        width: Get.width * 0.2,
                        controller: controller.amountCollectedController,
                      ),
                      const SizedBox(width: 16),

                      CustomTextField(
                        name: 'Deductions',
                        width: Get.width * 0.2,
                        controller: controller.dedcutionsController,
                      ),
                      const SizedBox(width: 16),

                      CustomTextField(
                        name: 'Amount Payable',
                        width: Get.width * 0.2,
                        controller: controller.amountPayableController,
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: Get.width * 0.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Cancel Date",
                              color: primaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            InkWell(
                              onTap:
                                  () => controller.selectDate(
                                    context,
                                    controller.cancelDateController,
                                  ),
                              child: AbsorbPointer(
                                child: CustomTextField(
                                  borderColor: secondaryColor,
                                  suffixIcon: const Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                  controller: controller.cancelDateController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Invoice Created Date missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomDashedLineWidget(width: Get.width),
                  const SizedBox(height: 24),
                  const CustomText(
                    text: 'Payment Mode',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Plan Type Dropdown
                      const SizedBox(width: 16),
                      CustomTextField(
                        name: 'Payment Mode',
                        width: Get.width * 0.2,
                        controller: controller.paymentModeController,
                      ),
                      const SizedBox(width: 16),

                      CustomTextField(
                        name: 'Bank',
                        width: Get.width * 0.2,
                        controller: controller.bankController,
                      ),
                      const SizedBox(width: 16),

                      SizedBox(
                        width: Get.width * 0.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Payment Date",
                              color: primaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            InkWell(
                              onTap:
                                  () => controller.selectDate(
                                    context,
                                    controller.paymentDateController,
                                  ),
                              child: AbsorbPointer(
                                child: CustomTextField(
                                  borderColor: secondaryColor,
                                  suffixIcon: const Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                  controller: controller.paymentDateController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Invoice Created Date missing";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CustomDashedLineWidget(width: Get.width),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomTextField(maxLines: 5, name: "Add Note"),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _buildPlanDetails(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Plan Details",
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 16),
            Obx(() {
              final planData =
                  controller
                      .jewelleryPlanResponse
                      .value
                      .data
                      ?.results
                      ?.firstOrNull;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _planDetailsWidget(
                    "Customer Name",
                    planData?.customerName ?? "-",
                  ),
                  const CustomDashedLineWidget(
                    width: 50,
                    orientation: DashOrientation.vertical,
                  ),
                  _planDetailsWidget("Phone Number", planData?.phone ?? "-"),
                  const CustomDashedLineWidget(
                    width: 50,
                    orientation: DashOrientation.vertical,
                  ),
                  _planDetailsWidget(
                    "Installment Amount",
                    planData?.cost.toString() ?? "-",
                  ),
                  const CustomDashedLineWidget(
                    width: 50,
                    orientation: DashOrientation.vertical,
                  ),
                  _planDetailsWidget("Start Date", planData?.createdOn ?? "-"),
                  const CustomDashedLineWidget(
                    width: 50,
                    orientation: DashOrientation.vertical,
                  ),
                  _planDetailsWidget(
                    "Installment Number",
                    planData?.installments ?? "-",
                  ),
                  const CustomDashedLineWidget(
                    width: 50,
                    orientation: DashOrientation.vertical,
                  ),
                  _planDetailsWidget(
                    "Weight/ Installment",
                    planData?.weightOrAmount ?? "-",
                  ),
                  SizedBox(width: Get.width * 0.3),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Column _planDetailsWidget(String detailType, String detailValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: detailType,
          color: primaryColor,
          fontSize: 12,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          text: detailValue,
          fontSize: 16,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

class AvailableFilterWidget extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;

  const AvailableFilterWidget({super.key, required this.onSelectionChanged});

  @override
  AvailableFilterWidgetState createState() => AvailableFilterWidgetState();
}

class AvailableFilterWidgetState extends State<AvailableFilterWidget> {
  final List<String> _metalTypes = [
    'Ring',
    'Chain',
    'Bangle',
    'Earring',
    'New Ornament',
  ];
  final List<String> _selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1428328B),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                focusColor: Colors.grey.shade300,
                onTap: () {
                  Get.back();
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/filter.svg',
                        // ignore: deprecated_member_use
                        color: redTextColor,
                      ),
                      const SizedBox(width: 8),
                      const CustomText(
                        text: "Close",
                        color: redTextColor,
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metal/Services Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: List.generate(_metalTypes.length, (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCheckBoxWidget(
                          value: _selectedTypes.contains(_metalTypes[index]),
                          onChanged: (value) {
                            setState(() {
                              if (_selectedTypes.contains(_metalTypes[index])) {
                                _selectedTypes.remove(_metalTypes[index]);
                              } else {
                                _selectedTypes.add(_metalTypes[index]);
                              }
                              widget.onSelectionChanged(_selectedTypes);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _metalTypes[index],
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 16),
                CustomButton1(
                  buttonName: "Submit",
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final SidebarController sidebarController = Get.find();

  FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            SizedBox(width: Get.width * 0.02),
            SingleChildScrollView(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      // controller.resetFields();
                      sidebarController.popBackSelectedWidget();
                    },
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
                      onTap: () {
                        Get.find<CancelPlanController>().cancelPlan();
                      },
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
                              text: "Next",
                              fontSize: 16,
                              color: whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomText(
                              text: " (ctrl + s)",
                              fontSize: 16,
                              color: whiteColor,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
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
}
