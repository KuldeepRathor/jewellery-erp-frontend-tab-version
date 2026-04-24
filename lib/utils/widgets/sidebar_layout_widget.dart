import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/sidebar_widget.dart';

class SidebarLayoutWidget extends StatelessWidget {
  const SidebarLayoutWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Positioned.fill(left: 76, child: child),
            // Sidebar
            const Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              child: SideBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
