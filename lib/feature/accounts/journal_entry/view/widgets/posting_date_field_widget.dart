import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view_model/journal_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class PostingDateField extends StatefulWidget {
  final JournalViewModel journalViewModel;

  const PostingDateField({super.key, required this.journalViewModel});

  @override
  State<PostingDateField> createState() => _PostingDateFieldState();
}

class _PostingDateFieldState extends State<PostingDateField> {
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Posting Date",
          color: primaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        InkWell(
          focusNode: _focusNode,
          onTap:
              () => widget.journalViewModel.selectDate(
                context,
                widget.journalViewModel.postingDateController,
              ),
          child: AbsorbPointer(
            child: CustomTextField(
              canRequestFocus: false,
              width: 250,
              suffixIcon: Icon(
                Icons.calendar_month_outlined,
                color: isFocused ? secondaryColor : Colors.grey,
              ),
              controller: widget.journalViewModel.postingDateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Posting Date missing";
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
