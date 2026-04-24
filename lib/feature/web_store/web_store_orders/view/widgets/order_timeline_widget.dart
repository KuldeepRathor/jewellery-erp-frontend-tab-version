import 'package:flutter/material.dart';

/// A model class to represent a timeline status item
class TimelineItem {
  /// The title/status of this timeline item (e.g., "In Progress", "Shipped")
  final String status;

  /// The date text to show (e.g., "20 Feb 2025")
  final String date;

  /// Optional time to show after the date (e.g., "5:32 Pm")
  final String? time;

  /// Whether this status has been completed
  final bool isCompleted;

  /// Optional reason text for statuses like Cancelled or Returned
  final String? reason;

  /// Optional image URL to show in detail cards (can be network URL or asset path)
  final String? detailImage;

  /// Optional tracking details to display
  final Map<String, String>? trackingDetails;

  /// Optional refund details to display
  final Map<String, String>? refundDetails;

  /// Optional invoice details for Returns
  final String? invoiceNumber;

  TimelineItem({
    required this.status,
    required this.date,
    this.time,
    required this.isCompleted,
    this.reason,
    this.detailImage,
    this.trackingDetails,
    this.refundDetails,
    this.invoiceNumber,
  });
}

class OrderTimeline extends StatelessWidget {
  /// List of timeline items to display
  final List<TimelineItem> items;

  /// The color for completed status indicators
  final Color completedColor;

  const OrderTimeline({
    super.key,
    required this.items,
    this.completedColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        items.length,
        (index) => _buildTimelineItem(
          context,
          item: items[index],
          isFirst: index == 0,
          isLast: index == items.length - 1,
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required TimelineItem item,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final hasDetails =
        item.trackingDetails != null || item.refundDetails != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: item.isCompleted ? completedColor : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: item.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: hasDetails
                    ? 100
                    : (item.reason != null || item.invoiceNumber != null
                        ? 45
                        : 30),
                color: item.isCompleted ? completedColor : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.status,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              if (item.time != null)
                Text(
                  "${item.date} | ${item.time}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                )
              else
                Text(
                  item.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
              if (item.reason != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Reason - ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.reason!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (item.invoiceNumber != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Sales Return Invoice No. - ${item.invoiceNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
              if (item.trackingDetails != null &&
                  item.trackingDetails!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDetailsCard(
                  title: 'Tracking Details',
                  details: item.trackingDetails!,
                  image: item.detailImage,
                ),
              ],
              if (item.refundDetails != null &&
                  item.refundDetails!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDetailsCard(
                  title: 'Refund Details',
                  details: item.refundDetails!,
                  showShadow: true,
                ),
              ],
              SizedBox(height: isLast ? 0 : 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard({
    required String title,
    required Map<String, String> details,
    String? image,
    bool showShadow = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _buildImage(image),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                ...details.entries.map(
                  (entry) => _buildDetailRow(entry.key, entry.value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to determine if image is a network URL or local asset
  Widget _buildImage(String imagePath) {
    final isNetworkImage =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 24),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 50,
            height: 50,
            color: Colors.grey[200],
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Local asset image
      return Image.asset(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 24),
          );
        },
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    final isLink = value.startsWith('http') ||
        label.toLowerCase().contains('tracking') ||
        label.toLowerCase().contains('number') ||
        label.toLowerCase().contains('company');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label - ',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isLink ? Colors.blue : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
