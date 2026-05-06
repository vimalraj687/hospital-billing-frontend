import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/patient_provider.dart';
import '../../billing/presentation/create_bill_dialog.dart';
import 'patient_form_dialog.dart';

class PatientListScreen extends ConsumerWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsyncValue = ref.watch(patientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const PatientFormDialog(),
              );
            },
          )
        ],
      ),
      body: patientsAsyncValue.when(
        data: (patients) {
          if (patients.isEmpty) {
            return const Center(child: Text('No patients found.'));
          }
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return ListTile(
                title: Text(patient['name']),
                subtitle: Text('Age: ${patient['age']} | Gender: ${patient['gender']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(patient['phone'] ?? ''),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.receipt_long, color: Colors.blue),
                      tooltip: 'Create Bill',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CreateBillDialog(
                            patientId: patient['_id'],
                            patientName: patient['name'],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      tooltip: 'Edit Patient',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => PatientFormDialog(patient: patient),
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
