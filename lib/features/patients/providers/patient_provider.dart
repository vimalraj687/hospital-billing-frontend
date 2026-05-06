import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/network/api_client.dart';

final patientsProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(apiClientProvider);
  final response = await dio.get('/patients');
  return response.data;
});

class PatientNotifier extends StateNotifier<bool> {
  final Ref ref;
  PatientNotifier(this.ref) : super(false);

  Future<void> addPatient(Map<String, dynamic> data) async {
    state = true;
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post('/patients', data: data);
      ref.invalidate(patientsProvider);
    } finally {
      state = false;
    }
  }

  Future<void> updatePatient(String id, Map<String, dynamic> data) async {
    state = true;
    try {
      final dio = ref.read(apiClientProvider);
      await dio.put('/patients/$id', data: data);
      ref.invalidate(patientsProvider);
    } finally {
      state = false;
    }
  }
}

final patientNotifierProvider = StateNotifierProvider<PatientNotifier, bool>((ref) {
  return PatientNotifier(ref);
});
