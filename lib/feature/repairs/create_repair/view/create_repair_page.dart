import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view/widgets/create_repair_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view/widgets/create_repair_party_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view/widgets/create_repair_payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view_model/create_repair_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view_model/create_repair_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class SaveRepairIntent extends Intent {
  const SaveRepairIntent();
}

class CreateRepairPage extends StatefulWidget {
  const CreateRepairPage({super.key});

  @override
  State<CreateRepairPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<CreateRepairPage> {
  final CreateRepairViewModel controller = Get.put<CreateRepairViewModel>(
    CreateRepairViewModel(),
  );
  final PartyDetailsController partyDetailsController =
      Get.put<PartyDetailsController>(PartyDetailsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.partyDetailsFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        SaveRepairIntent: CallbackAction<SaveRepairIntent>(
          onInvoke: (intent) async {
            Get.dialog(const CreateRepairPaymentDetailsDialog());
            return null;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveRepairIntent(),
        },
        child: FocusScope(
          autofocus: true,
          child: Scaffold(
            backgroundColor: grey1,
            body: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    HeaderWidget(
                      header: 'Create Repair',
                      wantBackButton: true,
                      onBackButtonTap: () {
                        SidebarController sidebarController = Get.find();
                        sidebarController.popBackSelectedWidget();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMobileVerify(),
                    _buildRepairDetails(),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: CreateRepairItemDetailsWidget(),
                      ),
                    ),
                    _footerWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileVerify() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width * 0.4,
            child: CreateRepairPartyDetailsWidget(
              isPurchase: true,
              focusNode: controller.partyDetailsFocusNode,
              nextFocusNode: controller.commodityTypeFocusNode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepairDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Repair Details',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              CustomDropdownField(
                focusNode: controller.commodityTypeFocusNode,
                name: 'Commodity Type',
                width: Get.width * .2,
                items: controller.commodityTypes,
                selectedItem: controller.selectedCommodity.value,
                onChanged: controller.onCommodityChanged,
              ),
              const SizedBox(width: 16),
              CustomTextField(
                enabled: false,
                name: "Repair No",
                hintText: 'Repair No',
                nameColor: blackColor,
                width: Get.width * 0.2,
              ),
              const SizedBox(width: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: "Repair Date",
                        fontSize: 12,
                        color: blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: Get.height * 0.01),
                      InkWell(
                        onTap: () {
                          controller.selectDate(
                            context,
                            controller.repairDateController,
                          );
                        },
                        child: Focus(
                          focusNode: controller.repairDateFocusNode,
                          onKeyEvent: (node, event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.enter) {
                              controller.employeeFocusNode.requestFocus();
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: AbsorbPointer(
                            child: SizedBox(
                              height: 34,
                              width: Get.width * 0.2,
                              child: TextField(
                                controller: controller.repairDateController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: secondaryColor,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: secondaryColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Repair Taken By",
                    color: primaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  Obx(() {
                    return SizedBox(
                      width: Get.width * .2,
                      child: GenericAutocompleteDropdown<GetEmployeesValue>(
                        controller: controller.employeeSearchController.value,
                        focusNode: controller.employeeFocusNode,
                        items: const [],
                        getDisplayValue:
                            (employee) =>
                                '${employee.firstName ?? ''} ${employee.lastName ?? ''}',
                        onSelected: (value) async {
                          controller.setSelectedEmployee(value);
                        },
                        customOptionsBuilder: (textEditingValue) async {
                          await controller.searchEmployees(
                            textEditingValue.text,
                          );
                          return controller.employeeOptions.toList();
                        },
                        borderColor: secondaryColor,
                        isLastRow: true,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CustomDropdownField(
                focusNode: controller.bookingTypeFocusNode,
                name: 'Booking Type',
                width: Get.width * .2,
                items: controller.bookingTypes,
                selectedItem: controller.selectedBooking.value,
                onChanged: (value) {
                  controller.onBookingChanged;

                  if (Get.isRegistered<CreateRepairItemDetailsController>()) {
                    final itemDetailsController =
                        Get.find<CreateRepairItemDetailsController>();
                    itemDetailsController.requestFirstFocus();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: whiteColor,
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              Get.dialog(const AddRemarkDialog());
            },
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
                  SizedBox(width: 4),
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
          SizedBox(width: Get.width * 0.01),
          InkWell(
            onTap: () {
              controller.clearAllControllers();
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
              onTap: () async {
                Get.dialog(const CreateRepairPaymentDetailsDialog());
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Save",
                          fontSize: 16,
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: CustomText(
                            text: "Ctrl + S",
                            fontSize: 12,
                            color: whiteColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
