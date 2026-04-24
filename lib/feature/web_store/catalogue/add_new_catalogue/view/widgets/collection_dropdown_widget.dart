import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/add_new_catalogue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/collection_listing/model/get_collections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class CollectionDropdownWidget extends StatelessWidget {
  const CollectionDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddNewCatalogueController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Choose Collection (Optional)",
          color: primaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: Get.height * 0.0125),
        Obx(() {
          return SizedBox(
            width: Get.width,
            child: GenericAutocompleteDropdown<GetAllCollectionsValue>(
              controller: controller.collectionSearchController.value,
              focusNode: controller.collectionFocusNode,
              items: controller.collectionOptions,
              getDisplayValue:
                  (collection) =>
                      collection.collectionName ?? 'Unknown Collection',
              onSelected: (value) {
                controller.setSelectedCollection(value);
              },
              customOptionsBuilder: (textEditingValue) async {
                await controller.searchCollections(textEditingValue.text);
                return controller.collectionOptions.toList();
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
