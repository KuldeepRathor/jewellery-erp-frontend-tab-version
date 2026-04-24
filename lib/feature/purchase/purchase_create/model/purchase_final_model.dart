import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';

class CreateInvoiceModel {
  List<ItemDetailsTableData> itemDetails = [];
  List<PaymentDetailsTableData> paymentMethodDetails = [];
  PaymentDetailsModel paymentDetails = PaymentDetailsModel();

  CreateInvoiceModel({
    required this.itemDetails,
    required this.paymentMethodDetails,
    required this.paymentDetails,
  });

  Map<String, dynamic> toJsonValue() {
    return {
      'item_details': itemDetails.map((item) => item.toJsonValue()).toList(),
      'payment_method_details':
          paymentMethodDetails.map((payment) => payment.toJsonValue()).toList(),
      'payment_details': paymentDetails.toJsonValue(),
    };
  }
}

class PaymentDetailsModel {
  String? sub_total;
  String? cgst;
  String? igst;
  String? round_off;
  String? tcs;
  String? tds;
  String? paid_amount;
  String? balance_amount;
  PaymentDetailsModel({
    this.balance_amount,
    this.cgst,
    this.igst,
    this.paid_amount,
    this.round_off,
    this.sub_total,
    this.tcs,
    this.tds,
  });
  Map<String, dynamic> toJsonValue() {
    return {
      'sub_total': sub_total,
      'cgst': cgst,
      'igst': igst,
      'round_off': round_off,
      'tcs': tcs,
      'tds': tds,
      'paid_amount': paid_amount,
      'balance_amount': balance_amount,
    };
  }
}
