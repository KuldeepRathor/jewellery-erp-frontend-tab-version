import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view/widgets/journal_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view/widgets/journal_entry_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view/widgets/journal_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view_model/journal_entry_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view_model/journal_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

// Define a custom intent for saving

class JournalEntryPage extends StatefulWidget {
  const JournalEntryPage({super.key});

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  final JournalViewModel journalViewModel = Get.put(JournalViewModel());
  final AccountTableController accountTableController = Get.put(
    AccountTableController(),
  );

  @override
  void initState() {
    super.initState();
    journalViewModel.fetchVoucherNumber();
    accountTableController.initializeController();
    accountTableController.fetchAccountMappings();
  }

  @override
  void dispose() {
    super.dispose();
    accountTableController.clearControllers();
    journalViewModel.clearControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const SaveJournalIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SaveJournalIntent: CallbackAction<SaveJournalIntent>(
            onInvoke: (intent) async {
              await journalViewModel.postJournalEntry();
              return null;
            },
          ),
        },
        child: FocusScope(
          autofocus: true,
          child: Scaffold(
            body: Column(
              children: [
                const JournalHeaderWidget(),
                JournalDetailsWidget(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                      top: 0,
                    ),
                    child: AccountTableView(),
                  ),
                ),
                _footerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: whiteColor,
      child: Row(
        children: [
          const Spacer(),
          SizedBox(width: Get.width * 0.01),
          InkWell(
            onTap: () {
              accountTableController.clearControllers();
              accountTableController.addRow();
              journalViewModel.clearControllers();
            },
            child: Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: CustomText(
                  text: "Discard",
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: Get.width * 0.01),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => journalViewModel.postJournalEntry(),
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 38,
                width: 140,
                child: Center(
                  child: Obx(
                    () =>
                        journalViewModel.postJournalResponse.value.status ==
                                Status.LOADING
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : ButtonShortcutWidget(
                              buttonName: "Save",
                              shortcut: "Ctrl + S",
                              buttonsize: 16,
                              color: whiteColor,
                              shortcutButtonColor: primaryColor,
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
