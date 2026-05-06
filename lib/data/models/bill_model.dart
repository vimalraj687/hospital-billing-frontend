import 'package:hospital_billing_client/data/models/service_model.dart';

class BillModel {
  final String id;

  final String patientId;

  final double totalAmount;

  final double discount;

  final double tax;

  final double finalAmount;

  final double paidAmount;

  final String paymentStatus;

  final List<ServiceModel> services;

  final DateTime createdAt;

  BillModel({
    required this.id,
    required this.patientId,
    required this.totalAmount,
    required this.discount,
    required this.tax,
    required this.finalAmount,
    required this.paidAmount,
    required this.paymentStatus,
    required this.services,
    required this.createdAt,
  });

  // 🔥 JSON → Dart Object
  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      finalAmount: (json['finalAmount'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'PENDING',
      services: (json['services'] as List<dynamic>? ?? [])
          .map((item) => ServiceModel.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // 🔥 Dart Object → JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'totalAmount': totalAmount,
      'discount': discount,
      'tax': tax,
      'finalAmount': finalAmount,
      'paidAmount': paidAmount,
      'paymentStatus': paymentStatus,
      'services': services.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
