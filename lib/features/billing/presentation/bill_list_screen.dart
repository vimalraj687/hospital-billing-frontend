import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/billing_provider.dart';
import 'standalone_create_bill_dialog.dart';
import 'update_payment_dialog.dart';

class BillListScreen extends ConsumerWidget {
  const BillListScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final billsAsyncValue =
        ref.watch(billsProvider);

    return Scaffold(
      backgroundColor:
          const Color(0xfff4f7fb),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Hospital Bills',

          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),

        iconTheme:
            const IconThemeData(
          color: Colors.black87,
        ),

        actions: [
          // HOME BUTTON
          Padding(
            padding:
                const EdgeInsets.only(
              right: 12,
            ),

            child: OutlinedButton.icon(
              onPressed: () {
                context.go('/');
              },

              icon: const Icon(
                Icons.home,
                size: 18,
              ),

              label: const Text(
                'Home',
              ),

              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    Colors.blue.shade700,

                side: BorderSide(
                  color: Colors
                      .blue
                      .shade200,
                ),

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),
          ),

          // CREATE BILL BUTTON
          Padding(
            padding:
                const EdgeInsets.only(
              right: 20,
            ),

            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,

                  builder: (context) =>
                      const StandaloneCreateBillDialog(),
                );
              },

              icon:
                  const Icon(Icons.add),

              label:
                  const Text(
                'Create Bill',
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue.shade700,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: billsAsyncValue.when(
        data: (bills) {
          if (bills.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 70,
                    color:
                        Colors.grey[400],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text(
                    'No bills found.',

                    style: TextStyle(
                      color:
                          Colors.grey[600],

                      fontSize: 20,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding:
                const EdgeInsets.all(
              24,
            ),

            itemCount: bills.length,

            separatorBuilder:
                (context, index) =>
                    const SizedBox(
              height: 18,
            ),

            itemBuilder:
                (context, index) {
              final bill =
                  bills[index];

              final patientName =
                  bill['patientId'] !=
                          null
                      ? bill['patientId']
                          ['name']
                      : 'Unknown';

              final isPaid =
                  bill['paymentStatus']
                          .toString()
                          .toUpperCase() ==
                      'PAID';

              return AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 250,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(
                        0.04,
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

                child: ListTile(
                  onTap: () {
                    context.go(
                      '/bills/details',

                      extra: bill,
                    );
                  },

                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 22,
                  ),

                  // LEADING
                  leading: Container(
                    width: 58,
                    height: 58,

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
                                    .shade600,
                                Colors.orange
                                    .shade400,
                              ],
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),
                    ),

                    child: Icon(
                      isPaid
                          ? Icons
                              .check_circle
                          : Icons
                              .pending_actions,

                      color:
                          Colors.white,

                      size: 30,
                    ),
                  ),

                  // TITLE
                  title: Text(
                    patientName,

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,

                      fontSize: 18,
                    ),
                  ),

                  // SUBTITLE
                  subtitle: Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 12,
                    ),

                    child: Row(
                      children: [
                        Text(
                          'Total: \$${bill['finalAmount']}',

                          style:
                              TextStyle(
                            color: Colors
                                .grey[800],

                            fontWeight:
                                FontWeight
                                    .w600,

                            fontSize:
                                15,
                          ),
                        ),

                        const SizedBox(
                          width: 18,
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration:
                              BoxDecoration(
                            color: isPaid
                                ? Colors
                                    .green
                                    .shade50
                                : Colors
                                    .orange
                                    .shade50,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),

                          child: Text(
                            '${bill['paymentStatus']}',

                            style:
                                TextStyle(
                              color: isPaid
                                  ? Colors
                                      .green
                                      .shade700
                                  : Colors
                                      .orange
                                      .shade700,

                              fontSize:
                                  12,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TRAILING
                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      // PAID AMOUNT
                      Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,

                        children: [
                          const Text(
                            'Paid Amount',

                            style:
                                TextStyle(
                              fontSize:
                                  12,

                              color:
                                  Colors
                                      .grey,
                            ),
                          ),

                          Text(
                            '\$${bill['paidAmount']}',

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,

                              fontSize:
                                  16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        width: 18,
                      ),

                      // INVOICE BUTTON
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go(
                            '/bills/details',

                            extra: bill,
                          );
                        },

                        icon: const Icon(
                          Icons.download,
                          size: 18,
                        ),

                        label: const Text(
                          'Invoice',
                        ),

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue
                                  .shade600,

                          foregroundColor:
                              Colors.white,

                          elevation: 0,

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                18,
                            vertical:
                                14,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                      ),

                      // PAYMENT BUTTON
                      if (!isPaid) ...[
                        const SizedBox(
                          width: 10,
                        ),

                        IconButton(
                          icon:
                              const Icon(
                            Icons.payment,
                            color:
                                Colors.blue,
                          ),

                          tooltip:
                              'Add Payment',

                          onPressed: () {
                            showDialog(
                              context:
                                  context,

                              builder:
                                  (context) =>
                                      UpdatePaymentDialog(
                                bill:
                                    bill,
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },

        loading: () =>
            const Center(
          child:
              CircularProgressIndicator(),
        ),

        error:
            (error, stack) => Center(
          child: Text(
            'Error: $error',
          ),
        ),
      ),
    );
  }
}