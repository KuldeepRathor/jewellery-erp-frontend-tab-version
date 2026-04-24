import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view/widgets/collection_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view/widgets/design_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view/widgets/gemstone_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view/widgets/image_gallery_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view/widgets/metal_color_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view/widgets/metal_purity_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/add_new_catalogue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/catalogue_image_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/gemstones_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/metal_color_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/catalogue_listing/view_model/order_to_make_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class EditCatalogueWidget extends StatefulWidget {
  const EditCatalogueWidget({super.key});

  @override
  State<EditCatalogueWidget> createState() => _EditCatalogueWidgetState();
}

class _EditCatalogueWidgetState extends State<EditCatalogueWidget> {
  @override
  Widget build(BuildContext context) {
    Get.put(GemstonesController());
    Get.put(MetalColorController());
    Get.put(ImageUploadController());
    // final catalogueListingController = Get.put(CatalogueListingController());
    final catalogueController = Get.put(AddNewCatalogueController());

    return GetBuilder<OrderToMakeListingController>(
      init: OrderToMakeListingController(),
      builder: (catalogueListingController) {
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ImageGalleryWidget(),
                        SizedBox(height: Get.height * 0.025),
                        CustomDashedLineWidget(width: Get.width),
                        SizedBox(height: Get.height * 0.025),

                        // Form Fields
                        const Text('Design name :'),
                        SizedBox(height: Get.height * 0.0125),
                        TextFormField(
                          controller: catalogueController.designNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.025),

                        const DesignDropdownWidget(),
                        SizedBox(height: Get.height * 0.0125),
                        const Divider(),
                        SizedBox(height: Get.height * 0.0125),
                        const Text('Weight Range:'),
                        SizedBox(height: Get.height * 0.0125),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'),
                                  ),
                                ],
                                controller:
                                    catalogueController.minWeightController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  hintText: 'Min',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'),
                                  ),
                                ],
                                controller:
                                    catalogueController.maxWeightController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  hintText: 'Max',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.025),

                        MetalPurityFilter(),
                        SizedBox(height: Get.height * 0.025),

                        const MetalColorDropdownWidget(),
                        SizedBox(height: Get.height * 0.025),

                        const GemstonesDropdownWidget(),
                        SizedBox(height: Get.height * 0.025),

                        const Text('Stone Weight:'),
                        SizedBox(height: Get.height * 0.0125),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'),
                                  ),
                                ],
                                controller:
                                    catalogueController.stoneWeightController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value:
                                      catalogueController.stoneRateType.value,
                                  underline: const SizedBox(),
                                  icon: Icon(
                                    Icons.unfold_more,
                                    size: 18,
                                    color: Colors.grey[600],
                                  ),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      catalogueController.stoneRateType.value =
                                          newValue;
                                    }
                                  },
                                  items:
                                      <String>[
                                        'ct',
                                        'gm',
                                        'pcs',
                                      ].map<DropdownMenuItem<String>>((
                                        String value,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase()),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.025),
                        const Divider(),
                        SizedBox(height: Get.height * 0.0125),

                        const CollectionDropdownWidget(),
                        SizedBox(height: Get.height * 0.025),
                        _buildRateField(
                          "Rate",
                          catalogueController.rateController,
                          validator: (String? v) {
                            return v;
                          },
                        ),
                        SizedBox(height: Get.height * 0.025),

                        // Mandatory Description Checkbox
                        Obx(
                          () => Row(
                            children: [
                              Checkbox(
                                value:
                                    catalogueController
                                        .isMandatoryDescription
                                        .value,
                                onChanged:
                                    catalogueController
                                        .toggleMandatoryDescription,
                              ),
                              const Text('Mandatory Description'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => catalogueController.discard(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: const Text('Discard'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed:
                                      catalogueController.isUploading.value
                                          ? null
                                          : () =>
                                              catalogueListingController
                                                      .editProductId
                                                      .value
                                                      .isNotEmpty
                                                  ? catalogueController
                                                      .saveCatalogue(
                                                        isEdit: true,
                                                        catId:
                                                            catalogueListingController
                                                                .editProductId
                                                                .value,
                                                      )
                                                  : catalogueController
                                                      .saveCatalogue(
                                                        isEdit: false,
                                                      ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child:
                                      catalogueController.isUploading.value
                                          ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                          : Text(
                                            catalogueListingController
                                                    .editProductId
                                                    .value
                                                    .isNotEmpty
                                                ? "Edit"
                                                : 'Save',
                                          ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRateField(
    String label,
    TextEditingController controller, {
    bool autoFocus = false,
    required String? Function(String?)? validator,
  }) {
    return CustomTextField(
      controller: controller,
      autofocus: autoFocus,
      name: label,
      width: Get.width * 0.3,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
      ],
      prefixIcon: const Icon(Icons.currency_rupee, size: 16),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return '$label is required';
      //   }
      //   if (double.tryParse(value) == null) {
      //     return 'Enter a valid number';
      //   }
      //   return null;
      // },
      validator: validator,
    );
  }
}
