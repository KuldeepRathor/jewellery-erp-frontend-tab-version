import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/model/get_tagging_line_item_editing_history_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/view_model/edit_tagged_items_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class HistoryWidget extends StatelessWidget {
  HistoryWidget({super.key, required this.context});

  final BuildContext context;
  final EditTaggedItemsViewModel controller =
      Get.find<EditTaggedItemsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with count badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Obx(() {
                    final totalCount =
                        controller
                            .getEditHistoryResponse
                            .value
                            .data
                            ?.totalCount;
                    if (totalCount != null && totalCount > 0) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomText(
                          text:
                              '$totalCount ${totalCount == 1 ? 'edit' : 'edits'}',
                          fontSize: 11,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // History content
              Expanded(
                child: Obx(() {
                  // Handle loading state
                  if (controller.getEditHistoryResponse.value.status ==
                      Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Handle error state
                  if (controller.getEditHistoryResponse.value.status ==
                      Status.ERROR) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.grey[400],
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load history',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              controller.fetchEditHistory();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Display the edit history
                  final historyData =
                      controller.getEditHistoryResponse.value.data;
                  final historyList = historyData?.editHistory ?? [];

                  if (historyList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            color: Colors.grey[300],
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No edit history',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Changes will appear here',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Display history list with created at section
                  return ListView.separated(
                    itemCount:
                        historyList.length + 1, // +1 for created at section
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      // Show edit history items first
                      if (index < historyList.length) {
                        final history = historyList[index];
                        return _buildHistoryItem(history);
                      }
                      // Show created at section last
                      else {
                        return null;
                        // _buildCreatedAtSection();
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(EditHistory history) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        // color: grey1,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and time
          if (history.createdAt != null)
            CustomText(
              text: _formatDateTimeForLog(history.createdAt!),
              fontSize: 14,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),

          const SizedBox(width: 8),

          const CustomText(
            text: ':',
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(width: 8),

          // Description
          Expanded(
            child: CustomText(
              text: _buildHistoryDescription(history),
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _buildHistoryDescription(EditHistory history) {
    // If displayText is available, use it
    if (history.displayText != null && history.displayText!.isNotEmpty) {
      return history.displayText!;
    }

    // Otherwise, build description from field name and old/new values
    final fieldName = history.editFieldName ?? history.editField ?? 'Field';
    final oldValue = history.oldValue ?? 'N/A';
    final newValue = history.newValue ?? 'N/A';

    return '$fieldName changed from $oldValue to $newValue';
  }

  String _formatDateTimeForLog(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final displayHour = hour == 0 ? 12 : hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year ($displayHour:$minute $period)';
  }
}
