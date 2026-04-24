import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/add_new_catalogue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class DesignDropdownWidget extends StatelessWidget {
  const DesignDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddNewCatalogueController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Choose design",
          color: primaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: Get.height * 0.0125),
        Obx(() {
          return SizedBox(
            width: Get.width,
            child: GenericAutocompleteDropdown<GetDesignResponseModel>(
              controller: controller.designSearchController.value,
              focusNode: controller.designFocusNode,
              items: const [],
              getDisplayValue: (design) => design.name ?? 'Unknown Design',
              onSelected: (value) {
                controller.setSelectedDesign(value);
              },
              customOptionsBuilder: (textEditingValue) async {
                await controller.searchDesigns(textEditingValue.text);
                return controller.designOptions.toList();
              },
              borderColor: secondaryColor,
              isLastRow: true,
            ),
          );
        }),
      ],
    );
  }
}
