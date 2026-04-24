import 'package:flutter/material.dart';

class LedgerDetailsWidget extends StatelessWidget {
  final String bankDetails;
  final String ledgerName;
  final String gst;
  final String address;
  final String outstandingCR;
  final String outstandingDR;

  const LedgerDetailsWidget({
    super.key,
    required this.bankDetails,
    required this.ledgerName,
    required this.gst,
    required this.address,
    required this.outstandingCR,
    required this.outstandingDR,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFE6E8FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Ledger Details',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 14,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // Bank Details Section

          // Ledger Info Row
          Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ledger Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ledger Name',
                        style: TextStyle(
                          color: Color(0xFF28328B),
                          fontSize: 14,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: Text(
                          ledgerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),

                  // GST
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GST',
                        style: TextStyle(
                          color: Color(0xFF28328B),
                          fontSize: 14,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: Text(
                          gst,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),

                  // Address
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address',
                        style: TextStyle(
                          color: Color(0xFF28328B),
                          fontSize: 14,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bank Details',
                    style: TextStyle(
                      color: Color(0xFF28328B),
                      fontSize: 14,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Text(
                      bankDetails,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Outstanding Info Row
              // Row(
              //   children: [
              //     // Outstanding CR
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Outstanding CR',
              //           style: TextStyle(
              //             color: Color(0xFF28328B),
              //             fontSize: 14,
              //             fontFamily: 'Satoshi',
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         const SizedBox(height: 4),
              //         Container(
              //           constraints: const BoxConstraints(maxWidth: 250),
              //           child: Text(
              //             outstandingCR,
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //             style: const TextStyle(
              //               color: Color(0xFFFC3A20),
              //               fontSize: 14,
              //               fontFamily: 'Satoshi',
              //               fontWeight: FontWeight.w700,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     const SizedBox(width: 32),

              //     // Outstanding DR
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Outstanding DR',
              //           style: TextStyle(
              //             color: Color(0xFF28328B),
              //             fontSize: 14,
              //             fontFamily: 'Satoshi',
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         const SizedBox(height: 4),
              //         Container(
              //           constraints: const BoxConstraints(maxWidth: 250),
              //           child: Text(
              //             outstandingDR,
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //             style: const TextStyle(
              //               color: Color(0xFFFC3A20),
              //               fontSize: 14,
              //               fontFamily: 'Satoshi',
              //               fontWeight: FontWeight.w700,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),

              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }
}
