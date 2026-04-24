import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/post_daily_rates_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/view_model/daily_rates_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddSaveIntent extends Intent {
  const AddSaveIntent();
}

class AddDailyRatesDialog extends StatefulWidget {
  final String? rateId;

  const AddDailyRatesDialog({super.key, this.rateId});

  @override
  State<AddDailyRatesDialog> createState() => _AddDailyRatesDialogState();
}

class _AddDailyRatesDialogState extends State<AddDailyRatesDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController gold22kController = TextEditingController();
  final TextEditingController gold18kController = TextEditingController();
  final TextEditingController goldOthersController = TextEditingController();
  final TextEditingController gold24kController = TextEditingController();
  final TextEditingController silverController = TextEditingController();
  final TextEditingController silver999Controller = TextEditingController();

  final TextEditingController silver925Controller = TextEditingController();
  final TextEditingController platinumController = TextEditingController();

  final DailyRatesListingViewModel dailyRatesListingViewModel =
      Get.find<DailyRatesListingViewModel>();

  @override
  void initState() {
    super.initState();
    if (widget.rateId != null) {
      //  Fetch existing rate details if editing
    } else {
      // Set current date and time for new entries
      dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      timeController.text = DateFormat('HH:mm').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: FocusScope(
        autofocus: true,
        onKeyEvent: onNormalKeyEvent,
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const AddSaveIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              AddSaveIntent: CallbackAction<AddSaveIntent>(
                onInvoke: (AddSaveIntent intent) => _submitDailyRates(),
              ),
            },
            child: Container(
              height: Get.height * 0.63,
              width: Get.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildDailyRatesForm()),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyRatesForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap(
            //   children: [
            //     // _buildDateField(),
            //     SizedBox(width: 16),
            //     // _buildTimeField(),
            //   ],
            // ),
            // SizedBox(height: 16),
            const CustomText(
              text: "Gold",
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            const SizedBox(height: 16),
            Wrap(
              children: [
                _buildRateField(
                  "Gold 22k",
                  gold22kController,
                  autoFocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gold 22k is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(width: 16),
                _buildRateField(
                  "Gold 18k",
                  gold18kController,
                  validator: (value) {
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              children: [
                _buildRateField(
                  "Gold Others",
                  goldOthersController,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(width: 16),
                _buildRateField(
                  "Gold 24k",
                  gold24kController,
                  validator: (value) {
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: "Silver",
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            const SizedBox(height: 16),
            Wrap(
              children: [
                _buildRateField(
                  "Silver",
                  silverController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silver is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(width: 16),
                _buildRateField(
                  "Silver 999",
                  silver999Controller,
                  validator: (value) {
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              children: [
                _buildRateField(
                  "Silver 925",
                  silver925Controller,
                  validator: (value) {
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: "Platinum",
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            const SizedBox(height: 16),
            _buildRateField(
              "Platinum",
              platinumController,
              validator: (value) {
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDateField() {
  //   return CustomTextField(
  //     controller: dateController,
  //     name: 'Date',
  //     width: Get.width * 0.2,
  //     readOnly: true,
  //     onTap: () async {
  //       final DateTime? picked = await showDatePicker(
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(2000),
  //         lastDate: DateTime(2101),
  //       );
  //       if (picked != null) {
  //         dateController.text = DateFormat('dd/MM/yyyy').format(picked);
  //       }
  //     },
  //     suffixIcon: const Icon(Icons.calendar_today),
  //   );
  // }

  // Widget _buildTimeField() {
  //   return CustomTextField(
  //     controller: timeController,
  //     name: 'Time',
  //     width: Get.width * 0.2,
  //     readOnly: true,
  //     onTap: () async {
  //       final TimeOfDay? picked = await showTimePicker(
  //         context: context,
  //         initialTime: TimeOfDay.now(),
  //       );
  //       if (picked != null) {
  //         timeController.text = picked.format(context);
  //       }
  //     },
  //     suffixIcon: const Icon(Icons.access_time),
  //   );
  // }

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
      width: Get.width * 0.2,
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

  Widget _buildHeader() {
    return Container(
      height: 54,
      // width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text:
                widget.rateId == null ? 'Add Daily Rates' : 'Edit Daily Rates',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          Expanded(
            child: Row(
              children: [
                const Spacer(),
                Expanded(
                  child: CustomText(
                    text: DateFormat(
                      'd MMMM yyyy, h:mm a',
                    ).format(DateTime.now()),
                    // color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, -1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 160,
              height: 38,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CustomText(
                  text: "Cancel",
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: _submitDailyRates,
            child: Container(
              width: 160,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Save",
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: " (ctrl + s)",
                      color: whiteColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to handle empty text
  String getValueOrZero(TextEditingController controller) {
    return controller.text.trim().isEmpty ? "0" : controller.text.trim();
  }

  void _submitDailyRates() {
    if (formKey.currentState!.validate()) {
      log('Submitting daily rates');
      PostDailyRatesRequest request = PostDailyRatesRequest(
        price24K: getValueOrZero(gold24kController),
        price22K: getValueOrZero(gold22kController),
        pricePlain: getValueOrZero(goldOthersController),
        price18K: getValueOrZero(gold18kController),
        price23K: getValueOrZero(goldOthersController),
        price20K: getValueOrZero(goldOthersController),
        price14K: getValueOrZero(goldOthersController),
        price9K: getValueOrZero(goldOthersController),
        priceSilver999: getValueOrZero(silver999Controller),
        priceSilver925: getValueOrZero(silver925Controller),
        priceSilver: getValueOrZero(silverController),
        pricePlatinum: getValueOrZero(platinumController),
      );

      dailyRatesListingViewModel.postDailyRates(request: request);
      // Here you would typically call a method on your controller to save the data
      // Close the dialog after submission
    }
  }
}
