import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_categories_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';

class CategoryDropdownWidget extends StatefulWidget {
  final CategoryController categoryController;
  final String slideId;

  const CategoryDropdownWidget({
    super.key,
    required this.categoryController,
    required this.slideId,
  });

  @override
  State<CategoryDropdownWidget> createState() => _CategoryDropdownWidgetState();
}

class _CategoryDropdownWidgetState extends State<CategoryDropdownWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Initialize controller and focus node outside of the build method
    _controller = widget.categoryController.getControllerForSlide(
      widget.slideId,
    );
    _focusNode = widget.categoryController.getFocusNodeForSlide(widget.slideId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width,
          child: GenericAutocompleteDropdown<CategoriesResponse>(
            controller: _controller,
            focusNode: _focusNode,
            items: widget.categoryController.categoryOptions,
            getDisplayValue:
                (category) => category.categoryName ?? 'Unknown Category',
            onSelected: (value) {
              widget.categoryController.setSelectedCategory(
                widget.slideId,
                value,
              );
            },
            customOptionsBuilder: (textEditingValue) async {
              await widget.categoryController.searchCategories(
                textEditingValue.text,
              );
              return widget.categoryController.categoryOptions.toList();
            },
            borderColor: secondaryColor,
            isLastRow: true,
          ),
        ),
      ],
    );
  }
}
