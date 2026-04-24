import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class AddAdvanceDetails extends StatefulWidget {
  const AddAdvanceDetails({super.key});

  @override
  State<AddAdvanceDetails> createState() => _AddAdvanceDetailsState();
}

class _AddAdvanceDetailsState extends State<AddAdvanceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        children: [
          CustomHeaderWidget(header: 'Booking Details', wantBackButton: true),
          const SizedBox(height: 15),
          _buildBookingDetails(),
          const SizedBox(height: 15),
          _buildPaymentDetails(),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'User Details',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'User Name',
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 5),
                        CustomText(text: 'Koshish', fontSize: 16),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      height: 40,
                      width: 1,
                      color: grey2,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Phone Number',
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 5),
                        CustomText(text: '+91 62666759580', fontSize: 16),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CustomDashedLineWidget(width: Get.width),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Booking Details',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Booking ID',
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            CustomText(text: 'H6', fontSize: 16),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 40,
                          width: 1,
                          color: grey2,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Booking Date',
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            CustomText(text: '07/10/2024', fontSize: 16),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 40,
                          width: 1,
                          color: grey2,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Booking Rate/gm',
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            CustomText(text: '6,000.00', fontSize: 16),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 40,
                          width: 1,
                          color: grey2,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Booking Weight',
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            CustomText(text: '20 gms', fontSize: 16),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 40,
                          width: 1,
                          color: grey2,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Advance Paid',
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            CustomText(text: '39,000.00', fontSize: 16),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Booking Status',
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 5),
                CustomText(
                  text: 'In Progress',
                  fontSize: 16,
                  color: totalGreenColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: 'Payment Details',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              Row(
                children: [
                  const CustomText(
                    text: '+ Add Advance Amount',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: grey1,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const CustomText(
                      text: 'Enter',
                      fontSize: 12,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Table(
            // columnWidths: vendor_column_widths,
            children: const [
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: secondaryColor,
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Sn', color: whiteColor, fontSize: 16),
                      CustomText(
                        text: 'Payment Date',
                        color: whiteColor,
                        fontSize: 16,
                      ),
                      CustomText(
                        text: 'Amount (₹)',
                        color: whiteColor,
                        fontSize: 16,
                      ),
                      CustomText(
                        text: 'Payment ID',
                        color: whiteColor,
                        fontSize: 16,
                      ),
                      CustomText(
                        text: 'Payment Mode',
                        color: whiteColor,
                        fontSize: 16,
                      ),
                      CustomText(
                        text: 'Reference Number',
                        color: whiteColor,
                        fontSize: 16,
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
              TableRow(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: ' 01', fontSize: 16),
                      CustomText(text: '14/12/2024', fontSize: 16),
                      CustomText(text: '5000', fontSize: 16),
                      CustomText(text: 'PY272E1', fontSize: 16),
                      CustomText(text: 'Cash', fontSize: 16),
                      CustomText(text: 'B1234', fontSize: 16),
                      Icon(Icons.delete, color: redTextColor),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
