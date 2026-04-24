import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/get_webstore_order_detail_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/order_timeline_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view_model/webstore_orders_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebStoreOrdersViewModel>(
      init: WebStoreOrdersViewModel(),
      builder: (controller) {
        final ApiResponse<WebStoreOrderDetailByIdResponse> oD =
            controller.getWebStoreOrderResponseById.value;
        if (oD.data != null) {
          final orderItem = oD.data!;
          double subTotal = double.tryParse(orderItem.subTotal ?? "0.0") ?? 0.0;
          double discount = double.tryParse(orderItem.discount ?? "0.0") ?? 0.0;
          double tax = double.tryParse(orderItem.tax ?? "0.0") ?? 0.0;
          double shippingCharges =
              double.tryParse(orderItem.shippingCharges ?? "0.0") ?? 0.0;
          double totalPayable =
              double.tryParse(orderItem.totalAmountWithShipping ?? "0.0") ??
              0.0;
          return Container(
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1428328B),
                  blurRadius: 12,
                  offset: Offset(-8, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final controller =
                              Get.find<WebStoreOrdersViewModel>();
                          controller.hideItemDetails();
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Order ID - ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                orderItem.webstoreOrderNumber ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    orderItem.lineItem != null &&
                                            orderItem.lineItem!.images !=
                                                null &&
                                            orderItem
                                                .lineItem!
                                                .images!
                                                .isNotEmpty &&
                                            orderItem
                                                    .lineItem
                                                    ?.images
                                                    ?.first
                                                    .presignedUrl !=
                                                null
                                        ? InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                final imagePath =
                                                    orderItem
                                                        .lineItem!
                                                        .images!
                                                        .first
                                                        .presignedUrl!;
                                                return GlobalImageView(
                                                  imagePath: imagePath,
                                                );
                                              },
                                            );
                                          },
                                          child: Image.network(
                                            orderItem
                                                .lineItem!
                                                .images!
                                                .first
                                                .presignedUrl!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : const SizedBox.shrink(),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderItem.lineItem?.itemDescription ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Purity: Gold ${orderItem.lineItem?.purity ?? ""} | Gross Weight: ${orderItem.lineItem?.grossWeight ?? ""} gram',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Size: ${orderItem.lineItem?.size ?? ""} inches in width',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Shipping Address
                          _buildAddressSection(
                            'Shipping Address',
                            orderItem.shippingAddress,
                          ),
                          const SizedBox(height: 20),
                          // Billing Address
                          _buildAddressSection(
                            'Billing Address',
                            orderItem.billingAddress,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Payment Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentRow(
                            'Sub Total',
                            'Rs. ${subTotal.toStringAsFixed(2)}',
                            subtext: '(1 Items)',
                          ),
                          _buildPaymentRow(
                            'Discount',
                            discount.toStringAsFixed(2),
                          ),
                          _buildPaymentRow(
                            'Tax',
                            'Rs. ${tax.toStringAsFixed(2)}',
                          ),
                          _buildPaymentRow(
                            'Shipping Charges',
                            shippingCharges.toStringAsFixed(2),
                            valueColor: Colors.green,
                          ),
                          const Divider(height: 32),
                          _buildPaymentRow(
                            'Total Payment',
                            'Rs. ${totalPayable.toStringAsFixed(2)}',
                            isTotal: true,
                            subtext: '*Inclusive of all taxes',
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Order Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildOrderTimeline(orderItem),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildAddressSection(String title, IngAddress? address) {
    if (address == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (address.firstName != null || address.lastName != null)
                Text(
                  '${address.firstName ?? ''} ${address.lastName ?? ''}'.trim(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              if (address.firstName != null || address.lastName != null)
                const SizedBox(height: 4),
              if (address.addressLine1 != null &&
                  address.addressLine1!.isNotEmpty)
                Text(
                  address.addressLine1!,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              if (address.addressLine2 != null &&
                  address.addressLine2!.isNotEmpty)
                Text(
                  address.addressLine2!,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              const SizedBox(height: 4),
              Text(
                '${address.city ?? ''}, ${address.state ?? ''} ${address.pincode ?? ''}'
                    .trim(),
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              if (address.country != null)
                Text(
                  address.country!,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              if (address.phoneNumber != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${address.phoneCountryCode ?? ''} ${address.phoneNumber ?? ''}'
                            .trim(),
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(
    String label,
    String value, {
    String? subtext,
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTotal ? 15 : 14,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    color: Colors.grey[700],
                  ),
                ),
                if (subtext != null)
                  Text(
                    subtext,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format DateTime
  String _formatDate(dynamic date) {
    if (date == null) return '-';

    DateTime? dateTime;
    if (date is DateTime) {
      dateTime = date;
    } else if (date is String) {
      try {
        dateTime = DateTime.parse(date);
      } catch (e) {
        log('Error parsing date string: $date');
        return '-';
      }
    } else {
      return '-';
    }

    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  // Helper method to format DateTime with time
  String _formatDateTime(dynamic date) {
    if (date == null) return '-';

    DateTime? dateTime;
    if (date is DateTime) {
      dateTime = date;
    } else if (date is String) {
      try {
        dateTime = DateTime.parse(date);
      } catch (e) {
        log('Error parsing date string: $date');
        return '-';
      }
    } else {
      return '-';
    }

    return DateFormat('hh:mm a').format(dateTime);
  }

  Widget _buildOrderTimeline(WebStoreOrderDetailByIdResponse orderData) {
    final lineItem = orderData.lineItem;
    if (lineItem == null) return const SizedBox();

    final status = lineItem.status?.toLowerCase() ?? '';
    log("Order status: $status");

    List<TimelineItem> timelineItems = [];

    // Always add "In Progress" as the first item
    timelineItems.add(
      TimelineItem(
        status: 'In Progress',
        date: _formatDate(orderData.createdAt),
        time: _formatDateTime(orderData.createdAt),
        isCompleted: true,
      ),
    );

    // Add status-specific timeline items
    switch (status) {
      case 'delivered':
        // Add Shipped
        if (lineItem.shippingCompany != null ||
            lineItem.shipppingTrackingNumber != null) {
          timelineItems.add(
            TimelineItem(
              status: 'Shipped',
              date: _formatDate(lineItem.shippingTime),
              isCompleted: true,
              detailImage:
                  lineItem.shippingImages?.isNotEmpty == true
                      ? lineItem.shippingImages!.first.presignedUrl
                      : null,
              trackingDetails: {
                if (lineItem.shippingCompany != null)
                  'Company': lineItem.shippingCompany!,
                if (lineItem.shipppingTrackingNumber != null)
                  'Tracking Number': lineItem.shipppingTrackingNumber!,
              },
            ),
          );
        }
        // Add Delivered
        timelineItems.add(
          TimelineItem(
            status: 'Delivered',
            date: _formatDate(lineItem.deliveryTime),
            isCompleted: true,
          ),
        );
        break;

      case 'cancelled':
        // Add Shipped (if available)
        if (lineItem.shippingCompany != null ||
            lineItem.shipppingTrackingNumber != null) {
          timelineItems.add(
            TimelineItem(
              status: 'Shipped',
              date: _formatDate(lineItem.shippingTime),
              isCompleted: true,
              detailImage:
                  lineItem.shippingImages?.isNotEmpty == true
                      ? lineItem.shippingImages!.first.presignedUrl
                      : null,
              trackingDetails: {
                if (lineItem.shippingCompany != null)
                  'Company': lineItem.shippingCompany!,
                if (lineItem.shipppingTrackingNumber != null)
                  'Tracking Number': lineItem.shipppingTrackingNumber!,
              },
            ),
          );
        }
        // Add Cancelled
        timelineItems.add(
          TimelineItem(
            status: 'Cancelled',
            date: _formatDate(lineItem.cancelTime),
            isCompleted: true,
            reason: lineItem.reason,
            refundDetails:
                lineItem.refundAmount != null || lineItem.refundId != null
                    ? {
                      if (lineItem.refundTime != null)
                        'Refund Date': _formatDate(lineItem.refundTime),
                      if (lineItem.refundAmount != null)
                        'Refund Amt': 'Rs. ${lineItem.refundAmount}',
                      if (lineItem.refundId != null)
                        'Refund Id': lineItem.refundId!,
                    }
                    : null,
          ),
        );
        break;

      case 'returned':
        // Add Shipped
        if (lineItem.shippingCompany != null ||
            lineItem.shipppingTrackingNumber != null) {
          timelineItems.add(
            TimelineItem(
              status: 'Shipped',
              date: _formatDate(lineItem.shippingTime),
              isCompleted: true,
              detailImage:
                  lineItem.shippingImages?.isNotEmpty == true
                      ? lineItem.shippingImages!.first.presignedUrl
                      : null,
              trackingDetails: {
                if (lineItem.shippingCompany != null)
                  'Company': lineItem.shippingCompany!,
                if (lineItem.shipppingTrackingNumber != null)
                  'Tracking Number': lineItem.shipppingTrackingNumber!,
              },
            ),
          );
        }
        // Add Delivered
        if (lineItem.deliveryTime != null) {
          timelineItems.add(
            TimelineItem(
              status: 'Delivered',
              date: _formatDate(lineItem.deliveryTime),
              isCompleted: true,
            ),
          );
        }
        // Add Returned
        timelineItems.add(
          TimelineItem(
            status: 'Returned',
            date: _formatDate(lineItem.returnTime),
            isCompleted: true,
            invoiceNumber:
                lineItem.returnInvoiceNumber?.isNotEmpty == true
                    ? lineItem.returnInvoiceNumber
                    : null,
            refundDetails:
                lineItem.refundAmount != null || lineItem.refundId != null
                    ? {
                      if (lineItem.refundTime != null)
                        'Refund Date': _formatDate(lineItem.refundTime),
                      if (lineItem.refundAmount != null)
                        'Refund Amt': 'Rs. ${lineItem.refundAmount}',
                      if (lineItem.refundId != null)
                        'Refund Id': lineItem.refundId!,
                    }
                    : null,
          ),
        );
        break;

      case 'shipped':
        // Add Shipped
        timelineItems.add(
          TimelineItem(
            status: 'Shipped',
            date: _formatDate(lineItem.shippingTime),
            isCompleted: true,
            detailImage:
                lineItem.shippingImages?.isNotEmpty == true
                    ? lineItem.shippingImages!.first.presignedUrl
                    : null,
            trackingDetails: {
              if (lineItem.shippingCompany != null)
                'Company': lineItem.shippingCompany!,
              if (lineItem.shipppingTrackingNumber != null)
                'Tracking Number': lineItem.shipppingTrackingNumber!,
            },
          ),
        );
        break;

      case 'in progress':
      default:
        // Only "In Progress" item is shown (already added above)
        break;
    }

    return OrderTimeline(items: timelineItems);
  }
}
