import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/billing_provider.dart';

class UpdatePaymentDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic> bill;

  const UpdatePaymentDialog({super.key, required this.bill});

  @override
  ConsumerState<UpdatePaymentDialog> createState() => _UpdatePaymentDialogState();
}

class _UpdatePaymentDialogState extends ConsumerState<UpdatePaymentDialog> {
  final _paidAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _paidAmountController.text = '';
  }

  @override
  void dispose() {
    _paidAmountController.dispose();
    super.dispose();
  }

  void _submit() async {
    final paidAmount = double.tryParse(_paidAmountController.text) ?? 0.0;
    
    if (paidAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final data = {
      'paidAmount': paidAmount,
    };

    await ref.read(billingNotifierProvider.notifier).updatePayment(widget.bill['_id'], data);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(billingNotifierProvider);
    
    final finalAmount = (widget.bill['finalAmount'] as num?)?.toDouble() ?? 0.0;
    final paidAmount = (widget.bill['paidAmount'] as num?)?.toDouble() ?? 0.0;
    final remaining = finalAmount - paidAmount;

    return AlertDialog(
      title: const Text('Add Payment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Final Amount: \$${finalAmount.toStringAsFixed(2)}'),
            Text('Already Paid: \$${paidAmount.toStringAsFixed(2)}'),
            Text('Remaining: \$${remaining.toStringAsFixed(2)}', 
              style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _paidAmountController,
              decoration: const InputDecoration(labelText: 'Amount to Pay Now'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isSubmitting ? null : _submit,
          child: isSubmitting 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) 
            : const Text('Update'),
        ),
      ],
    );
  }
}
