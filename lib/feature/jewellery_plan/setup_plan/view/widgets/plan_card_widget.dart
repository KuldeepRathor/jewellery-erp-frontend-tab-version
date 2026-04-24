// plan_card_widget.dart
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_setup_plan_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class PlanCardWidget extends StatelessWidget {
  final GetSetupPlanListingValue plan;
  final VoidCallback? onTap;

  const PlanCardWidget({super.key, required this.plan, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(blurRadius: 6, color: Colors.grey[200]!, spreadRadius: 1),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildAmount(),
                const SizedBox(height: 16),
                _buildPlanDetails(),
                const SizedBox(height: 8),
              ],
            ),
            _buildBenefits(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Plan Name',
                fontSize: 12,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
                color: toolTipBgColor,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: plan.planName ?? 'N/A',
                fontSize: 20,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          // Note: Update status logic based on your requirements
          // if (plan.isActive)
          //   const StatusBadge(text: "Active", color: totalGreenColor)
          // else if (plan.isPaused)
          //   const StatusBadge(text: "Paused", color: tertiaryColor),
        ],
      ),
    );
  }

  Widget _buildAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Amount',
            fontSize: 12,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
            color: toolTipBgColor,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomText(
                text: plan.prefixedAmount ?? 'N/A',
                fontSize: 20,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                text: plan.minSipAmount ?? 'N/A',
                fontSize: 20,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
              const CustomText(text: " - "),
              CustomText(
                text: plan.maxSipAmount ?? 'N/A',
                fontSize: 20,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDetailColumn('Plan Type', plan.planType ?? 'N/A'),
          _buildDetailColumn(
            'Plan Period',
            plan.planDuration != null ? '${plan.planDuration} Months' : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 12,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
          color: toolTipBgColor,
        ),
        const SizedBox(height: 4),
        CustomText(
          text: value,
          fontSize: 16,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildBenefits() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 126,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          color: primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Plan Benefits',
              fontSize: 12,
              color: whiteColor,
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plan.planBenifit != null &&
                        plan.planBenifit!.isNotEmpty)
                      ...plan.planBenifit!.map(
                        (benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: "•",
                                fontSize: 16,
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CustomText(
                                  text: benefit.trim(),
                                  fontSize: 16,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const CustomText(
                        text: 'No benefits specified',
                        fontSize: 16,
                        color: whiteColor,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: CustomText(
        text: text,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
