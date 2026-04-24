import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/item_details_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';

class ItemDetailsDialogWidget extends StatelessWidget {
  const ItemDetailsDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dialogController = Get.put(ItemDetailsDialogController());
    final estimationController = Get.find<EstimationItemDetailsController>();

    return Container(
      height: Get.height * 0.8,
      width: Get.width * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "Item Details",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: redTextColor),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Obx(() {
            final index = dialogController.selectedIndex.value;

            if (estimationController.controllers.isEmpty) {
              return const Center(child: Text("No Data"));
            }

            final item = estimationController.controllers[index];

            return Row(
              children: [
                _buildDetailRow(
                  'Item Name/ Design',
                  item.item_description.text,
                ),
                _buildDetailRow('Pcs', item.pcs.text),
                _buildDetailRow('Size', "-"),
                _buildDetailRow('VA', item.va.text),
                _buildDetailRow('Mc', item.mc.text),
                _buildDetailRow('Stock', "-"),
              ],
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            height: 163,
            child: _buildImageGallery(estimationController, dialogController),
          ),
          const SizedBox(height: 20),
          Obx(() {
            final index = dialogController.selectedIndex.value;
            final employee =
                estimationController.controllers[index].employeeDetails;
            return Row(
              children: [
                const Icon(Icons.person, color: blackColor),
                const SizedBox(width: 20),
                const CustomText(
                  text: "Sales Person",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                const SizedBox(width: 20),
                CustomText(
                  text:
                      "${employee?.firstName ?? ""} ${employee?.lastName ?? ""} ",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          CustomDashedLineWidget(width: Get.width),
          const SizedBox(height: 10),
          const CustomText(
            text: "Stone Details",
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: blackColor,
          ),
          const SizedBox(height: 20),
          _buildStoneDetails(estimationController, dialogController),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(
              color: secondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(
    EstimationItemDetailsController estimationItemDetailsController,
    ItemDetailsDialogController dialogController,
  ) {
    return Obx(() {
      final index = dialogController.selectedIndex.value;
      final images = estimationItemDetailsController.controllers[index].images;
      log("The images are $images");

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.isEmpty ? 1 : images.length,
        itemBuilder: (context, index) {
          if (images.isEmpty) {
            return _buildImageCard(context: context);
          }
          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildImageCard(imageUrl: images[index], context: context),
          );
        },
      );
    });
  }

  Widget _buildImageCard({String? imageUrl, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return GlobalImageView(imagePath: imageUrl ?? "");
          },
        );
      },
      child: Container(
        width: 163,
        height: 163,
        decoration: ShapeDecoration(
          image:
              imageUrl != null
                  ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                  : null,
          color: imageUrl == null ? primaryColor : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            imageUrl == null
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/svgs/error/no_image_found.svg',
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildStoneDetails(
    EstimationItemDetailsController estimationItemDetailsController,
    ItemDetailsDialogController dialogController,
  ) {
    return Obx(() {
      final index = dialogController.selectedIndex.value;
      final stoneDetails =
          estimationItemDetailsController
              .controllers[index]
              .stoneDetailsTableData;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Stone Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(250 - 15),
                1: FixedColumnWidth(80 - 20),
                2: FixedColumnWidth(150 - 15),
                3: FixedColumnWidth(150 - 20),
                4: FixedColumnWidth(150 - 10),
                5: FixedColumnWidth(150 - 10),
              },
              children: [
                _buildTableRow([
                  'Stone Name',
                  'Pcs',
                  'Weight',
                  'Unit',
                  'Rate',
                  'Value',
                ], isHeader: true),
                if (stoneDetails.isEmpty)
                  _buildTableRow(['-', '-', '-', '-', '-', '-'])
                else
                  ...stoneDetails.map(
                    (stone) => _buildTableRow([
                      stone.name.text,
                      stone.pcs.text,
                      stone.carat_weight.text,
                      stone.weightUnitFromBackend,
                      stone.rate.text,
                      stone.total.text,
                    ]),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children:
          cells
              .map(
                (cell) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Text(
                    cell,
                    style: TextStyle(
                      color: isHeader ? Colors.black : secondaryColor,
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal,
                      fontSize: isHeader ? 12 : 16,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
