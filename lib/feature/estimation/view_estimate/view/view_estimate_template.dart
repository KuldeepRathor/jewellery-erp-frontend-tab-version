import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/view_estimate/view/view_estimate_page.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/view_estimate/view_model/view_estimation_controller.dart';

class ViewEstimateTemplate extends StatelessWidget {
  final String estimateId;

  const ViewEstimateTemplate({super.key, required this.estimateId});

  @override
  Widget build(BuildContext context) {
    final ViewEstimationController controller = Get.put(
      ViewEstimationController(),
    );

    // Fetch the data when the widget is built
    controller.getEstimationRecordByIdAggregate(id: estimateId);

    return Obx(() {
      final apiResponse = controller.getEstimateByIdResponse.value;

      if (apiResponse.status == Status.LOADING) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (apiResponse.status == Status.ERROR) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${apiResponse.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => controller.getEstimationRecordByIdAggregate(
                        id: estimateId,
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      if (apiResponse.status == Status.COMPLETED && apiResponse.data != null) {
        // Pass the response model directly
        return EstimateViewPage(estimateResponse: apiResponse.data!);
      }

      // Default case (should not reach here normally)
      return const Scaffold(body: Center(child: Text('Something went wrong')));
    });
  }
}
