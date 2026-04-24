import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_dashboard.dart/view/reports_dashboard_constant.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_dashboard.dart/view/reports_navigation.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';

class ReportsDashboard extends StatefulWidget {
  const ReportsDashboard({super.key});

  @override
  State<ReportsDashboard> createState() => _ReportsDashboardState();
}

class _ReportsDashboardState extends State<ReportsDashboard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyL):
            const SwitchToOverviewTabIntent(),
      },
      child: FocusScope(
        autofocus: true,
        child: Scaffold(
          backgroundColor: grey1,
          body: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  "assets/svgs/auth/background.svg",
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(header: 'Reports'),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: Get.width * 0.1,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: Get.width * 0.1,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Column(children: []),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Daily Reports Section
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Tooltip(
                            message:
                                ReportsDashboardConstants.dailyReportsTitle,
                            child: Text(
                              ReportsDashboardConstants.dailyReportsTitle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomDashedLineWidget(width: Get.width - 300),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReportsGrid(
                      ReportsDashboardConstants.dailyReports,
                      ReportsDashboardConstants.dailyCardType,
                    ),

                    // Tagging Reports Section
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Text(
                            ReportsDashboardConstants.taggingReportsTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomDashedLineWidget(width: Get.width - 300),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReportsGrid(
                      ReportsDashboardConstants.taggingReports,
                      ReportsDashboardConstants.taggingCardType,
                    ),

                    // Item Reports Section
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Text(
                            ReportsDashboardConstants.itemReportsTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomDashedLineWidget(width: Get.width - 300),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReportsGrid(
                      ReportsDashboardConstants.itemReports,
                      ReportsDashboardConstants.itemCardType,
                    ),

                    // Stock Reports Section
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Text(
                            ReportsDashboardConstants.stockReportsTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomDashedLineWidget(width: Get.width - 300),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReportsGrid(
                      ReportsDashboardConstants.stockReports,
                      ReportsDashboardConstants.stockCardType,
                    ),

                    // Accounting Reports Section
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Text(
                            ReportsDashboardConstants.accountingReportsTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomDashedLineWidget(width: Get.width - 300),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReportsGrid(
                      ReportsDashboardConstants.accountingReports,
                      ReportsDashboardConstants.accountingCardType,
                    ),

                    // Others Section
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Text(
                            ReportsDashboardConstants.othersTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomDashedLineWidget(width: Get.width - 300),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReportsGrid(
                      ReportsDashboardConstants.otherReports,
                      ReportsDashboardConstants.othersCardType,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsGrid(
    List<Map<String, dynamic>> reports,
    String cardType,
  ) {
    final rbacController = Get.find<RBACController>();
    final filteredReports =
        reports.where((report) {
          final pageCode = report['pageCode'] as int?;
          if (pageCode == null) return true; // Show if no code specified
          return rbacController.hasPage(pageCode);
        }).toList();

    if (filteredReports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No reports available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ReportsDashboardConstants.gridCrossAxisCount,
          childAspectRatio: ReportsDashboardConstants.gridChildAspectRatio,
          crossAxisSpacing: ReportsDashboardConstants.gridCrossAxisSpacing,
          mainAxisSpacing: ReportsDashboardConstants.gridMainAxisSpacing,
        ),
        itemCount: filteredReports.length, // CHANGED
        itemBuilder: (context, index) {
          final report = filteredReports[index]; // CHANGED
          return _buildActionCard(
            icon: report['icon'],
            title: report['title'],
            color: secondaryColor,
            cardType: cardType,
          );
        },
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required String cardType,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          _handleReportTap(title, cardType);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 38),
              const SizedBox(width: 6),
              Expanded(
                child: Tooltip(
                  message: title,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReportTap(String title, String cardType) {
    log('Selected $title in $cardType section');

    // First show a toast message for feedback
    showSuccessToast(
      message: ReportsDashboardConstants.getReportNavigationMessage(title),
    );

    // Navigate using the navigation class
    ReportsDashboardNavigation.handleReportTap(title, cardType);
  }
}
