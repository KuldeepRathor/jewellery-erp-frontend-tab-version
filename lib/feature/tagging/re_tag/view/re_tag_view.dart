import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/re_tag/view_model/re_tag_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg_flutter.dart';

class ReTagView extends StatefulWidget {
  const ReTagView({super.key});

  @override
  ReTagViewState createState() => ReTagViewState();
}

class ReTagViewState extends State<ReTagView> {
  final ReTagController controller = Get.put(ReTagController());
  final FocusNode itemCodeFocusNode = FocusNode();
  final FocusNode tagNoFocusNode = FocusNode();
  final FocusNode fetchButtonFocusNode = FocusNode();

  List<FocusNode> getIgnoreFocusList() {
    return [itemCodeFocusNode, tagNoFocusNode, fetchButtonFocusNode];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemCodeFocusNode.requestFocus();
    });
    controller.onClearCallback = () {
      itemCodeFocusNode.requestFocus();
    };
  }

  @override
  void dispose() {
    itemCodeFocusNode.dispose();
    tagNoFocusNode.dispose();
    fetchButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        DiscardIntent: CallbackAction<DiscardIntent>(
          onInvoke: (intent) {
            controller.clearAll();
            return;
          },
        ),
        AddSaveIntent: CallbackAction<AddSaveIntent>(
          onInvoke: (intent) {
            controller.printBarcode();
            controller.postTaggingLineItemReTag();
            return null;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP):
              const AddSaveIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyE):
              const EditPartyIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
        },
        child: FocusScope(
          autofocus: true,
          onKeyEvent:
              (node, event) =>
                  onNormalKeyEvent(node, event, getIgnoreFocusList()),
          child: Container(
            color: grey1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(header: 'Re-Tagging'),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.height * 0.02),
                            _buildTaggingInputSection(),
                            Obx(
                              () =>
                                  controller.hasData.value
                                      ? Column(
                                        children: [
                                          _buildItemDetailsSection(),
                                          _buildStoneDetailsSection(),
                                        ],
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FooterWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoneDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Stone Details',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            CustomDashedLineWidget(width: Get.width),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.tagData.value.lineStones == null ||
                  controller.tagData.value.lineStones!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CustomText(
                      text: 'No stone details available',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: grey1.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomText(
                            text: 'Stone Name',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Pcs',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            text: 'Weight',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            text: 'Rate',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            text: 'Value',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Rows
                  ...controller.tagData.value.lineStones!.asMap().entries.map((
                    entry,
                  ) {
                    int index = entry.key;
                    var stone = entry.value;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            index % 2 == 0
                                ? Colors.white
                                : grey1.withOpacity(0.2),
                        border: Border(
                          bottom: BorderSide(
                            color: grey1.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomText(
                              text: stone.name ?? '--',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: stone.pieces?.toString() ?? '--',
                              fontSize: 14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: stone.weight ?? '--',
                              fontSize: 14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '₹${stone.rate ?? '--'}',
                              fontSize: 14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: stone.total ?? '--',
                              fontSize: 14,
                              textAlign: TextAlign.right,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTaggingInputSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: 'Item Code',
                        fontSize: 14,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        capitalizeText: true,
                        controller: controller.itemCodeController,
                        focusNode: itemCodeFocusNode,
                        keyboardType: TextInputType.text,
                        hintText: "Enter item code",
                        onEditingComplete: () {
                          tagNoFocusNode.requestFocus();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter item code';
                          }
                          return null;
                        },
                        onChanged: (p0) {
                          final capitalizedValue = p0.toUpperCase();

                          final currentCursorPosition =
                              controller
                                  .itemCodeController
                                  .selection
                                  .baseOffset;

                          controller
                              .itemCodeController
                              .value = TextEditingValue(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(
                              offset: currentCursorPosition,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: 'Tag No.',
                        fontSize: 14,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        capitalizeText: true,
                        controller: controller.tagNoController,
                        focusNode: tagNoFocusNode,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter tag number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter tag number';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          // fetchButtonFocusNode.requestFocus();
                          controller.fetchTaggingDetails();
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // CustomButton1(
                //   focusNode: fetchButtonFocusNode,
                //   buttonName: "Fetch Details",
                //   onTap: () {
                //     controller.fetchTaggingDetails();
                //   },
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Item Details',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            CustomDashedLineWidget(width: Get.width),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildDetailsGrid()],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: Obx(() => _buildImageGallery())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Obx(
      () => Wrap(
        spacing: 32,
        runSpacing: 16,
        children: [
          _buildDetailItem(
            'Design Name',
            controller.tagData.value.design?.name ?? '--',
          ),
          _buildDetailItem('Weigh Group', controller.getWeightGroupName()),
          _buildDetailItem(
            'G.wt(gm)',
            controller.tagData.value.grossWeight ?? '--',
          ),
          _buildDetailItem(
            'N.wt(gm)',
            controller.tagData.value.netWeight ?? '--',
          ),
          _buildDetailItem('VA', controller.tagData.value.va ?? '--'),
          _buildDetailItem('MC', controller.tagData.value.mc ?? '--'),
          _buildDetailItem('Purity', controller.tagData.value.purity ?? '--'),
          _buildDetailItem(
            'Stone Details',
            controller.getStoneDetailsFormatted(),
          ),
          _buildDetailItem('Size', controller.getSizeValue()),
          _buildDetailItem(
            'Supplier',
            controller.tagData.value.vendorCode ?? "--",
          ),
          _buildDetailItem('HUID', controller.tagData.value.huid ?? '--'),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: label, fontSize: 14, color: primaryColor),
          const SizedBox(height: 8),
          CustomText(
            text: value.isEmpty ? '--' : value,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    if (controller.images.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset(
            'assets/svgs/error/no_image_found.svg',
            height: 120,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: controller.images.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(controller.images[index]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class FooterWidget extends StatelessWidget {
  final FocusNode? printCopiesFocusNode;

  FooterWidget({super.key, this.printCopiesFocusNode});
  final ReTagController controller = Get.put(ReTagController());

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
            // Print settings button
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => controller.openPrinterSettings(),
              tooltip: 'Printer Settings',
            ),
            // Print copies field
            SizedBox(
              width: 100,
              child: TextField(
                controller: controller.printCopiesController.value,
                focusNode: printCopiesFocusNode,
                decoration: InputDecoration(
                  labelText: 'Copies',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  controller.printBarcode();
                },
              ),
            ),
            const Spacer(),
            Row(
              children: [
                // Discard button
                InkWell(
                  onTap: () => controller.clearAll(),
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
                // Print button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      controller.printBarcode();
                      controller.postTaggingLineItemReTag();
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
                            text: "Print",
                            fontSize: 16,
                            color: whiteColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
