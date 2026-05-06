import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/network/api_client.dart';

final billsProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(apiClientProvider);
  final response = await dio.get('/bills');
  return response.data;
});

class BillingNotifier extends StateNotifier<bool> {
  final Ref ref;
  BillingNotifier(this.ref) : super(false);

  Future<void> createBill(Map<String, dynamic> data) async {
    state = true;
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post('/bills', data: data);
      ref.invalidate(billsProvider);
    } finally {
      state = false;
    }
  }

  Future<void> updatePayment(String id, Map<String, dynamic> data) async {
    state = true;
    try {
      final dio = ref.read(apiClientProvider);
      await dio.put('/bills/$id/payment', data: data);
      ref.invalidate(billsProvider);
    } finally {
      state = false;
    }
  }
}

final billingNotifierProvider = StateNotifierProvider<BillingNotifier, bool>((ref) {
  return BillingNotifier(ref);
});
