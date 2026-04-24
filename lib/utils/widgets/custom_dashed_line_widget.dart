import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

enum DashOrientation { horizontal, vertical }

class DashedLinePainter extends CustomPainter {
  final DashOrientation orientation;

  DashedLinePainter({this.orientation = DashOrientation.horizontal});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 10, dashSpace = 5, start = 0;
    final paint =
        Paint()
          ..color = grey2
          ..strokeWidth = 1;

    if (orientation == DashOrientation.horizontal) {
      while (start < size.width) {
        canvas.drawLine(Offset(start, 0), Offset(start + dashWidth, 0), paint);
        start += dashWidth + dashSpace;
      }
    } else {
      while (start < size.height) {
        canvas.drawLine(Offset(0, start), Offset(0, start + dashWidth), paint);
        start += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
// class CustomDashedLineWidget extends StatelessWidget {
//   const CustomDashedLineWidget({super.key, required this.width});
//   final double width;

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: DashedLinePainter(),
//       size: Size(width, 0),
//     );
//   }
// }
class CustomDashedLineWidget extends StatelessWidget {
  final double width;
  final DashOrientation orientation;

  const CustomDashedLineWidget({
    super.key,
    required this.width,
    this.orientation = DashOrientation.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(orientation: orientation),
      size:
          orientation == DashOrientation.horizontal
              ? Size(width, 0)
              : Size(0, width),
    );
  }
}
