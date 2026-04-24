import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_page_link_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';

class PageDropdownWidget extends StatefulWidget {
  final PageLinkController pageLinkController;
  final String slideId;

  const PageDropdownWidget({
    super.key,
    required this.pageLinkController,
    required this.slideId,
  });

  @override
  State<PageDropdownWidget> createState() => _PageDropdownWidgetState();
}

class _PageDropdownWidgetState extends State<PageDropdownWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Initialize controller and focus node outside of the build method
    _controller = widget.pageLinkController.getControllerForSlide(
      widget.slideId,
    );
    _focusNode = widget.pageLinkController.getFocusNodeForSlide(widget.slideId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width,
          child: GenericAutocompleteDropdown<PageLink>(
            controller: _controller,
            focusNode: _focusNode,
            items: widget.pageLinkController.pageOptions,
            getDisplayValue: (page) => page.name,
            onSelected: (value) {
              widget.pageLinkController.setSelectedPage(widget.slideId, value);
            },
            customOptionsBuilder: (textEditingValue) async {
              widget.pageLinkController.searchPages(textEditingValue.text);
              return widget.pageLinkController.pageOptions.toList();
            },
            borderColor: secondaryColor,
            isLastRow: true,
          ),
        ),
      ],
    );
  }
}
