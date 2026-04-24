import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/view/widget/category_and_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/view_model/add_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddNewCollection extends StatefulWidget {
  const AddNewCollection({super.key});

  @override
  State<AddNewCollection> createState() => _AddNewCollectionState();
}

class _AddNewCollectionState extends State<AddNewCollection> {
  final AddCollectionController controller = Get.put(AddCollectionController());
  final SidebarController sidebarController = Get.find<SidebarController>();
  final FocusNode categoryTextFieldFocus = FocusNode();
  final FocusNode designTextFieldFocus = FocusNode();
  final FocusNode collectionNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.clearControllers();
    controller.fetchCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(collectionNameFocus);
    });
  }

  @override
  void dispose() {
    // Dispose focus nodes
    categoryTextFieldFocus.dispose();
    designTextFieldFocus.dispose();
    collectionNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const NextReOrderIntent(),
      },
      child: Actions(
        actions: {
          NextReOrderIntent: CallbackAction<NextReOrderIntent>(
            onInvoke: (intent) {
              controller.handleSaveShortcut();
              return null;
            },
          ),
        },
        child: Scaffold(
          backgroundColor: secondaryColor.withOpacity(0.15),
          body: FocusScope(
            autofocus: true,
            child: Column(
              children: [
                HeaderWidget(
                  header: "Collection",
                  wantBackButton: true,
                  onBackButtonTap: () {
                    sidebarController.popBackSelectedWidget();
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      CustomTextField(
                        name: "Collection Name",
                        width: MediaQuery.of(context).size.width * 0.2,
                        controller: controller.collectionNameController,
                        focusNode: collectionNameFocus,
                        autofocus: true,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CategoryAndDesignWidget(
                  categoryTextFieldFocus: categoryTextFieldFocus,
                  controller: controller,
                  designTextFieldFocus: designTextFieldFocus,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Add a selection counter for designs
                          Obx(
                            () =>
                                controller.selectedDesigns.isNotEmpty
                                    ? Padding(
                                      padding: const EdgeInsets.only(
                                        right: 16.0,
                                      ),
                                      child: Text(
                                        "${controller.selectedDesigns.length} designs selected",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor,
                                        ),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                          CustomInkButton(
                            onPressed: () {
                              controller.handleSaveShortcut();
                            },
                            text: "Next (Ctrl+S)",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
