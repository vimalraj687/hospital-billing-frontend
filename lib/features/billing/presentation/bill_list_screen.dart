import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/billing_provider.dart';
import 'standalone_create_bill_dialog.dart';
import 'update_payment_dialog.dart';

class BillListScreen extends ConsumerWidget {
  const BillListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsyncValue = ref.watch(billsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const StandaloneCreateBillDialog(),
              );
            },
          )
        ],
      ),
      body: billsAsyncValue.when(
        data: (bills) {
          if (bills.isEmpty) {
            return const Center(child: Text('No bills found.'));
          }
          return ListView.builder(
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index];
              final patientName = bill['patientId'] != null ? bill['patientId']['name'] : 'Unknown';
              return ListTile(
                title: Text('Patient: $patientName'),
                subtitle: Text('Final: \$${bill['finalAmount']} | Status: ${bill['paymentStatus']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Paid: \$${bill['paidAmount']}'),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      tooltip: 'Update Payment',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => UpdatePaymentDialog(bill: bill),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
