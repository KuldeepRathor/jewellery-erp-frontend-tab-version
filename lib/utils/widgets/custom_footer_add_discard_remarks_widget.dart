import 'package:flutter/material.dart';

class CustomFooterAddDiscardRemark extends StatelessWidget {
  final VoidCallback onRemarkPressed;
  final VoidCallback onDiscardPressed;
  final VoidCallback? onNextPressed;
  final String remarkText;
  final String discardText;
  final String nextText;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final bool saveBtnVisibility;

  const CustomFooterAddDiscardRemark({
    super.key,
    required this.onRemarkPressed,
    required this.onDiscardPressed,
    required this.onNextPressed,
    this.remarkText = "Remarks",
    this.discardText = "Discard",
    this.nextText = "Next",
    this.primaryColor = const Color(0xFF28328B),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.textColor = Colors.white,
    this.saveBtnVisibility = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRemarkButton(),
          const Spacer(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildRemarkButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRemarkPressed,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          height: 38,
          width: 140,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit_outlined,
                color: primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                remarkText,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
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
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
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
