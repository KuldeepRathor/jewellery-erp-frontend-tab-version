import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/get_catalogue_metal_color_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/metal_color_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class MetalColorDailog extends StatefulWidget {
  final Function(GetCatalogMetalColorResponse) onMetalColorSelected;

  const MetalColorDailog({super.key, required this.onMetalColorSelected});

  @override
  State<MetalColorDailog> createState() => _MetalColorDailogState();
}

class _MetalColorDailogState extends State<MetalColorDailog> {
  final controller = Get.put<MetalColorController>(MetalColorController());
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        height: Get.height * .4,
        width: Get.width * .25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildMetalColorList()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            spreadRadius: .5,
            offset: Offset(0, 1),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Select Metal Color",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildMetalColorList() {
    return Obx(() {
      if (controller.getCatalogMetalColorResponse.value.status ==
          Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      final metalColors = controller.metalColorOptions;

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: metalColors.length,
        itemBuilder: (context, index) {
          final color = metalColors[index];

          final isSelected = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? secondaryColor.withOpacity(.1)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  color.colourName ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? secondaryColor : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            spreadRadius: .5,
            offset: Offset(0, -1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            if (selectedIndex != -1) {
              final selectedColor = controller.metalColorOptions[selectedIndex];
              widget.onMetalColorSelected(selectedColor);
              Get.back();
            }
          },
          child: Container(
            width: 110,
            height: 38,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
