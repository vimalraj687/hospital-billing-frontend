import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/billing_provider.dart';

class CreateBillDialog extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;

  const CreateBillDialog({super.key, required this.patientId, required this.patientName});

  @override
  ConsumerState<CreateBillDialog> createState() => _CreateBillDialogState();
}

class _CreateBillDialogState extends ConsumerState<CreateBillDialog> {
  final _serviceNameController = TextEditingController();
  final _servicePriceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _daysController = TextEditingController(text: '1');
  final _discountController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '0');
  
  String _serviceType = 'CONSULTATION';

  @override
  void dispose() {
    _serviceNameController.dispose();
    _servicePriceController.dispose();
    _quantityController.dispose();
    _daysController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_serviceNameController.text.isEmpty || _servicePriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter service name and price')),
      );
      return;
    }

    final price = double.tryParse(_servicePriceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final days = int.tryParse(_daysController.text) ?? 1;
    final discount = double.tryParse(_discountController.text) ?? 0.0;
    final tax = double.tryParse(_taxController.text) ?? 0.0;

    final billData = {
      'patientId': widget.patientId,
      'services': [
        {
          'type': _serviceType,
          'name': _serviceNameController.text,
          'quantity': quantity,
          'price': price,
          'days': days,
        }
      ],
      'discount': discount,
      'tax': tax,
    };

    await ref.read(billingNotifierProvider.notifier).createBill(billData);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bill created successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(billingNotifierProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text('Create Bill for ${widget.patientName}', style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _serviceType,
                decoration: InputDecoration(
                  labelText: 'Service Type',
                  prefixIcon: const Icon(Icons.medical_services_outlined),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
                items: const [
                  DropdownMenuItem(value: 'CONSULTATION', child: Text('Consultation')),
                  DropdownMenuItem(value: 'ROOM', child: Text('Room')),
                  DropdownMenuItem(value: 'LAB', child: Text('Lab Test')),
                  DropdownMenuItem(value: 'MEDICINE', child: Text('Medicine')),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value != null) _serviceType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _serviceNameController,
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  prefixIcon: const Icon(Icons.description_outlined),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _servicePriceController,
                      decoration: InputDecoration(
                        labelText: 'Unit Price',
                        prefixIcon: const Icon(Icons.attach_money_outlined),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: const Icon(Icons.numbers_outlined),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              if (_serviceType == 'ROOM') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _daysController,
                  decoration: InputDecoration(
                    labelText: 'Number of Days',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _discountController,
                      decoration: InputDecoration(
                        labelText: 'Discount',
                        prefixIcon: const Icon(Icons.money_off_outlined),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _taxController,
                      decoration: InputDecoration(
                        labelText: 'Tax',
                        prefixIcon: const Icon(Icons.account_balance_outlined),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      actions: [
        TextButton(
          onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          onPressed: isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: isSubmitting 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
            : const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
