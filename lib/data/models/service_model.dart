class ServiceModel {
  final String type;

  final String name;

  final int quantity;

  final int days;

  final double price;

  ServiceModel({
    required this.type,
    required this.name,
    required this.quantity,
    required this.days,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      days: json['days'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'quantity': quantity,
      'days': days,
      'price': price,
    };
  }
}
