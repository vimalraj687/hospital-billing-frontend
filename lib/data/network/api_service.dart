import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bill_model.dart';
import 'api_client.dart'; // From existing api_client.dart

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // --- Billing API Calls ---

  // Fetch all bills
  Future<List<BillModel>> fetchBills() async {
    try {
      final response = await _dio.get('/bills');
      final List<dynamic> data = response.data;
      return data.map((json) => BillModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load bills: ${e.message}');
    }
  }

  // Create a new bill
  Future<BillModel> createBill(Map<String, dynamic> billData) async {
    try {
      final response = await _dio.post('/bills', data: billData);
      return BillModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to create bill: ${e.response?.data['message'] ?? e.message}');
    }
  }

  // Update payment status
  Future<void> updateBillPayment(String billId, double paidAmount) async {
    try {
      await _dio.put('/bills/$billId/payment', data: {'paidAmount': paidAmount});
    } on DioException catch (e) {
      throw Exception('Failed to update payment: ${e.message}');
    }
  }
}

// Provider to inject the ApiService anywhere in the app
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ApiService(dio);
});
