import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';

class CustomFooterTaggedBy extends StatelessWidget {
  final VoidCallback onDiscardPressed;
  final VoidCallback? onNextPressed;
  final String taggedByText;
  final String discardText;
  final String nextText;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final bool saveBtnVisibility;
  final bool showActionButtons;

  const CustomFooterTaggedBy({
    super.key,
    required this.onDiscardPressed,
    this.onNextPressed,
    required this.taggedByText,
    this.discardText = "Discard",
    this.nextText = "Next",
    this.primaryColor = const Color(0xFF28328B),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.textColor = Colors.white,
    this.saveBtnVisibility = true,
    this.showActionButtons = true,
  });
  Future<GetEmployeesValue> fetchEmployeeDetails(String employeeId) async {
    final OrganizationRepository organizationRepository =
        OrganizationRepository();
    try {
      if (employeeId.isEmpty || employeeId == "-") {
        return GetEmployeesValue();
      }
      final response = await organizationRepository.getEmployeeById(employeeId);
      return response;
    } catch (e) {
      throw Exception('Error fetching employee details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTaggedBy(),
          if (showActionButtons) _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTaggedBy() {
    return FutureBuilder(
      future: fetchEmployeeDetails(taggedByText),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // return Text('Error: ${snapshot.error}');
          return const Text('-');
        } else if (snapshot.hasData) {
          final employee = snapshot.data!;
          return SizedBox(
            height: 38,
            child: Row(
              children: [
                Icon(Icons.person, color: primaryColor),
                const SizedBox(width: 8),
                SelectableText(
                  'Tagged By: ${employee.firstName ?? ""} ${employee.lastName ?? ""}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onDiscardPressed,
            borderRadius: BorderRadius.circular(8),
            child: Ink(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  discardText,
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onNextPressed,
            child: Ink(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Visibility(
                visible: saveBtnVisibility,
                replacement: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nextText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      " (ctrl + s)",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
