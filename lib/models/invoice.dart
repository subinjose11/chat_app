class Invoice {
  final String id;
  final String serviceOrderId;
  final String customerId;
  final String vehicleId;
  final String invoiceNumber;
  final DateTime issueDate;
  final DateTime dueDate;
  final double subtotal;
  final double tax;
  final double discount;
  final double totalAmount;
  final String status; // 'paid', 'unpaid', 'overdue'
  final String? paymentMethod;
  final DateTime? paidAt;

  Invoice({
    required this.id,
    required this.serviceOrderId,
    required this.customerId,
    required this.vehicleId,
    required this.invoiceNumber,
    required this.issueDate,
    required this.dueDate,
    required this.subtotal,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.totalAmount,
    this.status = 'unpaid',
    this.paymentMethod,
    this.paidAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? '',
      serviceOrderId: json['serviceOrderId'] ?? '',
      customerId: json['customerId'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'])
          : DateTime.now(),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now().add(const Duration(days: 30)),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'unpaid',
      paymentMethod: json['paymentMethod'],
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceOrderId': serviceOrderId,
      'customerId': customerId,
      'vehicleId': vehicleId,
      'invoiceNumber': invoiceNumber,
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paidAt': paidAt?.toIso8601String(),
    };
  }
}

