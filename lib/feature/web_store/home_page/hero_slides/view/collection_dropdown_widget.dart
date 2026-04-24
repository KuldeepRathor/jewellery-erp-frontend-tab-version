import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/collection_listing/model/get_collections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';

class CollectionDropdownWidget extends StatefulWidget {
  final CollectionController collectionController;
  final String slideId;

  const CollectionDropdownWidget({
    super.key,
    required this.collectionController,
    required this.slideId,
  });

  @override
  State<CollectionDropdownWidget> createState() =>
      _CollectionDropdownWidgetState();
}

class _CollectionDropdownWidgetState extends State<CollectionDropdownWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Initialize controller and focus node outside of the build method
    _controller = widget.collectionController.getControllerForSlide(
      widget.slideId,
    );
    _focusNode = widget.collectionController.getFocusNodeForSlide(
      widget.slideId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width,
          child: GenericAutocompleteDropdown<GetAllCollectionsValue>(
            controller: _controller,
            focusNode: _focusNode,
            items: widget.collectionController.collectionOptions,
            getDisplayValue:
                (collection) =>
                    collection.collectionName ?? 'Unknown Collection',
            onSelected: (value) {
              widget.collectionController.setSelectedCollection(
                widget.slideId,
                value,
              );
            },
            customOptionsBuilder: (textEditingValue) async {
              await widget.collectionController.searchCollections(
                textEditingValue.text,
              );
              return widget.collectionController.collectionOptions.toList();
            },
            borderColor: secondaryColor,
            isLastRow: true,
          ),
        ),
      ],
    );
  }
}
