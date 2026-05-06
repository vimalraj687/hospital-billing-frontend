import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/patient_provider.dart';

class PatientFormDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? patient; // Null means create, non-null means update

  const PatientFormDialog({super.key, this.patient});

  @override
  ConsumerState<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends ConsumerState<PatientFormDialog> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      _nameController.text = widget.patient!['name'] ?? '';
      _ageController.text = widget.patient!['age']?.toString() ?? '';
      _phoneController.text = widget.patient!['phone'] ?? '';
      _gender = widget.patient!['gender'] ?? 'Male';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final data = {
      'name': _nameController.text,
      'age': int.tryParse(_ageController.text) ?? 0,
      'gender': _gender,
      'phone': _phoneController.text,
    };

    if (widget.patient == null) {
      await ref.read(patientNotifierProvider.notifier).addPatient(data);
    } else {
      await ref.read(patientNotifierProvider.notifier).updatePatient(widget.patient!['_id'], data);
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.patient == null ? 'Patient created successfully' : 'Patient updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(patientNotifierProvider);

    return AlertDialog(
      title: Text(widget.patient == null ? 'Add Patient' : 'Edit Patient'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  if (value != null) _gender = value;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
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
            : Text(widget.patient == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}
