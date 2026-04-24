import 'package:get/get.dart';

class RemarksController extends GetxController {
  final RxString purchaseRemarks = ''.obs;
  void setPurchaseRemarkString({required String remarksSent}) {
    purchaseRemarks.value = remarksSent;
  }

  final RxString purchaseReturnRemarks = ''.obs;
  void setPurchaseReturnRemarkString({required String remarksSent}) {
    purchaseReturnRemarks.value = remarksSent;
  }

  final RxString designRemarks = ''.obs;
  void setDesignRemarkString({required String remarksSent}) {
    designRemarks.value = remarksSent;
  }
}
