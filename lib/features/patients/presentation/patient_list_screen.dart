import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/patient_provider.dart';

import '../../billing/presentation/create_bill_dialog.dart';
import '../../billing/presentation/standalone_create_bill_dialog.dart';

import 'patient_form_dialog.dart';

class PatientListScreen extends ConsumerWidget {
  const PatientListScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final patientsAsyncValue =
        ref.watch(
      patientsProvider,
    );

    return Scaffold(
      backgroundColor:
          const Color(0xfff4f7fb),

      appBar: AppBar(
        backgroundColor:
            Colors.white,

        elevation: 0,

        title: const Text(
          'Patients',

          style: TextStyle(
            color: Colors.black87,
            fontWeight:
                FontWeight.bold,
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

            child:
                OutlinedButton.icon(
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
                    Colors
                        .blue
                        .shade700,

                side: BorderSide(
                  color: Colors
                      .blue
                      .shade200,
                ),

                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      18,
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
              right: 12,
            ),

            child:
                ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context:
                      context,

                  builder:
                      (context) =>
                          const StandaloneCreateBillDialog(),
                );
              },

              icon: const Icon(
                Icons
                    .receipt_long,
              ),

              label: const Text(
                'Create Bill',
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue
                        .shade700,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      18,
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

          // ADD PATIENT BUTTON
          Padding(
            padding:
                const EdgeInsets.only(
              right: 16,
            ),

            child:
                ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context:
                      context,

                  builder:
                      (context) =>
                          const PatientFormDialog(),
                );
              },

              icon:
                  const Icon(
                Icons.add,
              ),

              label: const Text(
                'Add Patient',
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green
                        .shade600,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      18,
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
        ],
      ),

      body: patientsAsyncValue.when(
        data: (patients) {
          if (patients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64,
                    color:
                        Colors.grey[
                            400],
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Text(
                    'No patients found.',

                    style:
                        TextStyle(
                      color:
                          Colors.grey[
                              600],

                      fontSize:
                          18,
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

            itemCount:
                patients.length,

            separatorBuilder:
                (
                  context,
                  index,
                ) =>
                    const SizedBox(
              height: 16,
            ),

            itemBuilder:
                (
                  context,
                  index,
                ) {
              final patient =
                  patients[index];

              return Container(
                decoration:
                    BoxDecoration(
                  color:
                      Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors
                          .black
                          .withOpacity(
                        0.04,
                      ),

                      blurRadius:
                          8,

                      offset:
                          const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),

                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal:
                        24,
                    vertical: 12,
                  ),

                  leading:
                      CircleAvatar(
                    backgroundColor:
                        Theme.of(
                                context)
                            .colorScheme
                            .primaryContainer,

                    child: Icon(
                      Icons.person,

                      color: Theme.of(
                              context)
                          .colorScheme
                          .primary,
                    ),
                  ),

                  title: Text(
                    patient['name'],

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,

                      fontSize: 16,
                    ),
                  ),

                  subtitle: Text(
                    'Age: ${patient['age']} | Gender: ${patient['gender']}',
                  ),

                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      // PHONE
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              12,
                          vertical: 6,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.grey[
                                  100],

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),

                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 14,
                              color:
                                  Colors.grey[
                                      600],
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            Text(
                              patient[
                                      'phone'] ??
                                  '',

                              style:
                                  TextStyle(
                                color:
                                    Colors.grey[
                                        700],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      // CREATE BILL
                      IconButton(
                        icon:
                            const Icon(
                          Icons
                              .receipt_long,

                          color:
                              Colors.blue,
                        ),

                        tooltip:
                            'Create Bill',

                        onPressed:
                            () {
                          showDialog(
                            context:
                                context,

                            builder:
                                (
                                  context,
                                ) =>
                                    CreateBillDialog(
                              patientId:
                                  patient[
                                      '_id'],

                              patientName:
                                  patient[
                                      'name'],
                            ),
                          );
                        },
                      ),

                      // EDIT PATIENT
                      IconButton(
                        icon:
                            const Icon(
                          Icons.edit,

                          color:
                              Colors.orange,
                        ),

                        tooltip:
                            'Edit Patient',

                        onPressed:
                            () {
                          showDialog(
                            context:
                                context,

                            builder:
                                (
                                  context,
                                ) =>
                                    PatientFormDialog(
                              patient:
                                  patient,
                            ),
                          );
                        },
                      ),
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
            (
              error,
              stack,
            ) =>
                Center(
          child: Text(
            'Error: $error',
          ),
        ),
      ),
    );
  }
}