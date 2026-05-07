import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillDetailsScreen({
    super.key,
    required this.bill,
  });

  Future<void> _generateAndPrintPdf(
    BuildContext context,
  ) async {
    final pdf = pw.Document();

    final patientName =
        bill['patientId']?['name'] ?? 'Unknown';

    final services =
        bill['services'] as List<dynamic>? ?? [];

    final finalAmount =
        bill['finalAmount']?.toString() ?? '0';

    final discount =
        bill['discount']?.toString() ?? '0';

    final tax =
        bill['tax']?.toString() ?? '0';

    final paidAmount =
        bill['paidAmount']?.toString() ?? '0';

    final date = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(40),
          pageFormat: PdfPageFormat.a4,
        ),

        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment:
                pw.CrossAxisAlignment.start,

            children: [
              // HEADER
              pw.Container(
                padding:
                    const pw.EdgeInsets.all(
                  28,
                ),

                decoration: pw.BoxDecoration(
                  gradient:
                      const pw.LinearGradient(
                    colors: [
                      PdfColor.fromInt(
                        0xff1565C0,
                      ),
                      PdfColor.fromInt(
                        0xff42A5F5,
                      ),
                    ],
                  ),

                  borderRadius:
                      pw.BorderRadius.circular(
                    20,
                  ),
                ),

                child: pw.Row(
                  mainAxisAlignment:
                      pw.MainAxisAlignment
                          .spaceBetween,

                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          padding:
                              const pw.EdgeInsets
                                  .all(14),

                          decoration:
                              pw.BoxDecoration(
                            color:
                                PdfColors.white,

                            borderRadius:
                                pw.BorderRadius
                                    .circular(
                              14,
                            ),
                          ),

                          child: pw.Text(
                            '🏥',
                            style:
                                const pw.TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ),

                        pw.SizedBox(width: 18),

                        pw.Column(
                          crossAxisAlignment: pw
                              .CrossAxisAlignment
                              .start,

                          children: [
                            pw.Text(
                              'CITY HOSPITAL',
                              style: pw.TextStyle(
                                color:
                                    PdfColors.white,

                                fontSize: 26,

                                fontWeight: pw
                                    .FontWeight
                                    .bold,
                              ),
                            ),

                            pw.SizedBox(height: 4),

                            pw.Text(
                              'Medical Invoice',
                              style:
                                  const pw.TextStyle(
                                color:
                                    PdfColors.white,

                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    pw.Column(
                      crossAxisAlignment: pw
                          .CrossAxisAlignment
                          .end,

                      children: [
                        pw.Text(
                          'INVOICE',
                          style: pw.TextStyle(
                            color:
                                PdfColors.white,

                            fontSize: 22,

                            fontWeight: pw
                                .FontWeight
                                .bold,
                          ),
                        ),

                        pw.SizedBox(height: 6),

                        pw.Text(
                          date,
                          style:
                              const pw.TextStyle(
                            color:
                                PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // PATIENT INFO
              pw.Container(
                padding:
                    const pw.EdgeInsets.all(
                  24,
                ),

                decoration: pw.BoxDecoration(
                  color: PdfColors.white,

                  border: pw.Border.all(
                    color:
                        PdfColors.blue100,
                  ),

                  borderRadius:
                      pw.BorderRadius.circular(
                    18,
                  ),
                ),

                child: pw.Column(
                  crossAxisAlignment:
                      pw.CrossAxisAlignment
                          .start,

                  children: [
                    pw.Text(
                      'Patient Information',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight:
                            pw.FontWeight.bold,
                      ),
                    ),

                    pw.SizedBox(height: 18),

                    _pdfInfoRow(
                      'Patient Name',
                      patientName,
                    ),

                    _pdfInfoRow(
                      'Payment Status',
                      'PAID',
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // TABLE
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(
                  color: PdfColors.grey300,
                ),

                headerDecoration:
                    const pw.BoxDecoration(
                  color:
                      PdfColor.fromInt(
                    0xff1565C0,
                  ),
                ),

                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight:
                      pw.FontWeight.bold,
                ),

                cellPadding:
                    const pw.EdgeInsets.all(
                  14,
                ),

                data: [
                  [
                    'Service',
                    'Qty',
                    'Price',
                    'Total',
                  ],

                  ...services.map((item) {
                    final qty =
                        item['quantity'] ?? 1;

                    final price =
                        double.tryParse(
                              item['price']
                                      ?.toString() ??
                                  '0',
                            ) ??
                            0;

                    final total =
                        price * qty;

                    return [
                      item['name']
                              ?.toString() ??
                          '',
                      qty.toString(),
                      '\$${price.toStringAsFixed(2)}',
                      '\$${total.toStringAsFixed(2)}',
                    ];
                  }),
                ],
              ),

              pw.SizedBox(height: 30),

              // SUMMARY
              pw.Align(
                alignment:
                    pw.Alignment.centerRight,

                child: pw.Container(
                  width: 280,

                  padding:
                      const pw.EdgeInsets.all(
                    22,
                  ),

                  decoration: pw.BoxDecoration(
                    color:
                        PdfColors.blue50,

                    borderRadius:
                        pw.BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: pw.Column(
                    children: [
                      _pdfSummaryRow(
                        'Discount',
                        '\$$discount',
                      ),

                      pw.SizedBox(height: 12),

                      _pdfSummaryRow(
                        'Tax',
                        '\$$tax',
                      ),

                      pw.Divider(),

                      _pdfSummaryRow(
                        'Grand Total',
                        '\$$finalAmount',
                        isBold: true,
                      ),

                      pw.SizedBox(height: 12),

                      _pdfSummaryRow(
                        'Paid Amount',
                        '\$$paidAmount',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              pw.Divider(),

              pw.SizedBox(height: 24),

              // FOOTER
              pw.Row(
                mainAxisAlignment:
                    pw.MainAxisAlignment
                        .spaceBetween,

                children: [
                  pw.Column(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment
                            .start,

                    children: [
                      pw.Text(
                        'Authorized Signature',
                        style: pw.TextStyle(
                          fontWeight:
                              pw.FontWeight.bold,
                        ),
                      ),

                      pw.SizedBox(height: 40),

                      pw.Container(
                        width: 180,
                        height: 1,
                        color: PdfColors.black,
                      ),
                    ],
                  ),

                  pw.Text(
                    'Thank you for choosing City Hospital',
                    style: pw.TextStyle(
                      color: PdfColors.grey700,
                      fontStyle:
                          pw.FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout:
          (PdfPageFormat format) async =>
              pdf.save(),

      name:
          'Invoice_${patientName.replaceAll(' ', '_')}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final patientName =
        bill['patientId']?['name'] ?? 'Unknown';

    final services =
        bill['services'] as List<dynamic>? ?? [];

    final isPaid =
        bill['paymentStatus']
                .toString()
                .toUpperCase() ==
            'PAID';

    return Scaffold(
      backgroundColor:
          const Color(0xfff4f7fb),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Invoice Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme:
            const IconThemeData(
          color: Colors.black,
        ),

        actions: [
          if (isPaid)
            Padding(
              padding:
                  const EdgeInsets.only(
                right: 16,
              ),

              child: ElevatedButton.icon(
                onPressed: () =>
                    _generateAndPrintPdf(
                  context,
                ),

                icon:
                    const Icon(Icons.download),

                label:
                    const Text('Download PDF'),

                style:
                    ElevatedButton.styleFrom(
                  elevation: 0,

                  backgroundColor:
                      const Color(
                    0xff1565C0,
                  ),

                  foregroundColor:
                      Colors.white,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(30),

        child: Center(
          child: Container(
            constraints:
                const BoxConstraints(
              maxWidth: 980,
            ),

            padding:
                const EdgeInsets.all(36),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                32,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.blue
                      .withOpacity(
                    0.08,
                  ),

                  blurRadius: 30,

                  spreadRadius: 2,

                  offset:
                      const Offset(0, 12),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // HEADER
                Container(
                  padding:
                      const EdgeInsets.all(
                    30,
                  ),

                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(
                      begin:
                          Alignment.topLeft,

                      end: Alignment
                          .bottomRight,

                      colors: [
                        Color(0xff1565C0),
                        Color(0xff42A5F5),
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets
                                    .all(18),

                            decoration:
                                BoxDecoration(
                              color: Colors.white
                                  .withOpacity(
                                0.15,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                            ),

                            child: const Icon(
                              Icons.local_hospital,
                              color:
                                  Colors.white,

                              size: 42,
                            ),
                          ),

                          const SizedBox(
                            width: 22,
                          ),

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: const [
                              Text(
                                'CITY HOSPITAL',
                                style: TextStyle(
                                  color:
                                      Colors.white,

                                  fontSize: 30,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              SizedBox(
                                height: 8,
                              ),

                              Text(
                                'Medical Invoice',
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white70,

                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),

                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            colors: isPaid
                                ? [
                                    Colors.green
                                        .shade600,
                                    Colors.green
                                        .shade400,
                                  ]
                                : [
                                    Colors.orange
                                        .shade700,
                                    Colors.orange
                                        .shade400,
                                  ],
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            50,
                          ),
                        ),

                        child: Text(
                          isPaid
                              ? 'PAID'
                              : 'PENDING',

                          style:
                              const TextStyle(
                            color:
                                Colors.white,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 34),

                // PATIENT INFO
                Container(
                  padding:
                      const EdgeInsets.all(
                    28,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    border: Border.all(
                      color:
                          Colors.blue.shade50,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.03,
                        ),

                        blurRadius: 16,

                        offset:
                            const Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      const Text(
                        'Patient Information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 26,
                      ),

                      Wrap(
                        spacing: 60,
                        runSpacing: 24,

                        children: [
                          _infoItem(
                            'Patient Name',
                            patientName,
                          ),

                          _infoItem(
                            'Doctor',
                            'Dr. Sharma',
                          ),

                          _infoItem(
                            'Invoice ID',
                            '#INV-2026',
                          ),

                          _infoItem(
                            'Status',
                            isPaid
                                ? 'PAID'
                                : 'PENDING',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 34),

                // MODERN SERVICES TABLE
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      28,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.04,
                        ),

                        blurRadius: 20,

                        offset:
                            const Offset(
                          0,
                          10,
                        ),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // TABLE HEADER
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 28,
                          vertical: 22,
                        ),

                        decoration:
                            const BoxDecoration(
                          gradient:
                              LinearGradient(
                            colors: [
                              Color(
                                0xff1565C0,
                              ),
                              Color(
                                0xff42A5F5,
                              ),
                            ],
                          ),

                          borderRadius:
                              BorderRadius.only(
                            topLeft:
                                Radius.circular(
                              28,
                            ),

                            topRight:
                                Radius.circular(
                              28,
                            ),
                          ),
                        ),

                        child: Row(
                          children: const [
                            Expanded(
                              flex: 4,

                              child: Text(
                                'Service',

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight
                                          .bold,

                                  fontSize:
                                      15,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                'Qty',

                                textAlign:
                                    TextAlign
                                        .center,

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,

                              child: Text(
                                'Price',

                                textAlign:
                                    TextAlign
                                        .end,

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,

                              child: Text(
                                'Total',

                                textAlign:
                                    TextAlign
                                        .end,

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // TABLE BODY
                      ...List.generate(
                        services.length,
                        (index) {
                          final item =
                              services[index];

                          final qty =
                              item['quantity'] ??
                                  1;

                          final price =
                              double.tryParse(
                                    item['price']
                                            ?.toString() ??
                                        '0',
                                  ) ??
                                  0;

                          final total =
                              price * qty;

                          return Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 28,
                              vertical: 22,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  index.isEven
                                      ? Colors
                                          .white
                                      : const Color(
                                          0xfff7fbff,
                                        ),

                              border: Border(
                                bottom:
                                    BorderSide(
                                  color: Colors
                                      .grey
                                      .shade100,
                                ),
                              ),
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,

                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,

                                        decoration:
                                            BoxDecoration(
                                          color: Colors
                                              .blue
                                              .shade50,

                                          borderRadius:
                                              BorderRadius.circular(
                                            14,
                                          ),
                                        ),

                                        child: Icon(
                                          Icons
                                              .medical_services,

                                          color:
                                              Colors.blue[
                                                  700],

                                          size: 20,
                                        ),
                                      ),

                                      const SizedBox(
                                        width:
                                            16,
                                      ),

                                      Expanded(
                                        child:
                                            Text(
                                          item['name']
                                                  ?.toString() ??
                                              '',

                                          style:
                                              const TextStyle(
                                            fontSize:
                                                15,

                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    qty.toString(),

                                    textAlign:
                                        TextAlign
                                            .center,

                                    style:
                                        TextStyle(
                                      color:
                                          Colors.grey[
                                              700],

                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,

                                  child: Text(
                                    '\$${price.toStringAsFixed(2)}',

                                    textAlign:
                                        TextAlign
                                            .end,

                                    style:
                                        TextStyle(
                                      color:
                                          Colors.grey[
                                              800],

                                      fontWeight:
                                          FontWeight
                                              .w500,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,

                                  child: Text(
                                    '\$${total.toStringAsFixed(2)}',

                                    textAlign:
                                        TextAlign
                                            .end,

                                    style:
                                        TextStyle(
                                      color:
                                          Colors.blue[
                                              800],

                                      fontWeight:
                                          FontWeight
                                              .bold,

                                      fontSize:
                                          15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 34),

                // SUMMARY
                Align(
                  alignment:
                      Alignment.centerRight,

                  child: Container(
                    width: 340,

                    padding:
                        const EdgeInsets.all(
                      28,
                    ),

                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        colors: [
                          Colors.blue
                              .shade50,
                          Colors.blue
                              .shade100,
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                    ),

                    child: Column(
                      children: [
                        _summaryRow(
                          'Discount',
                          '\$${bill['discount'] ?? 0}',
                        ),

                        _summaryRow(
                          'Tax',
                          '\$${bill['tax'] ?? 0}',
                        ),

                        _summaryRow(
                          'Paid Amount',
                          '\$${bill['paidAmount'] ?? 0}',
                        ),

                        const Divider(
                          height: 34,
                        ),

                        _summaryRow(
                          'Grand Total',
                          '\$${bill['finalAmount'] ?? 0}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoItem(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [
          Text(
            title,
            style: TextStyle(
              fontSize:
                  isBold ? 24 : 15,

              fontWeight: isBold
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),

          Text(
            value,
            style: TextStyle(
              fontSize:
                  isBold ? 24 : 16,

              fontWeight:
                  FontWeight.bold,

              color:
                  Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

pw.Widget _pdfSummaryRow(
  String title,
  String value, {
  bool isBold = false,
}) {
  return pw.Row(
    mainAxisAlignment:
        pw.MainAxisAlignment
            .spaceBetween,

    children: [
      pw.Text(
        title,
        style: pw.TextStyle(
          fontSize:
              isBold ? 18 : 13,

          fontWeight: isBold
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        ),
      ),

      pw.Text(
        value,
        style: pw.TextStyle(
          fontSize:
              isBold ? 18 : 13,

          fontWeight:
              pw.FontWeight.bold,

          color: PdfColors.blue800,
        ),
      ),
    ],
  );
}

pw.Widget _pdfInfoRow(
  String title,
  String value,
) {
  return pw.Padding(
    padding:
        const pw.EdgeInsets.only(
      bottom: 12,
    ),

    child: pw.Row(
      mainAxisAlignment:
          pw.MainAxisAlignment
              .spaceBetween,

      children: [
        pw.Text(
          '$title:',
          style: pw.TextStyle(
            fontWeight:
                pw.FontWeight.bold,
          ),
        ),

        pw.Text(value),
      ],
    ),
  );
}