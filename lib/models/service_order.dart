class ServiceOrder {
  final String id;
  final String vehicleId;
  final String customerId;
  final String serviceType;
  final String description;
  final List<String> partsUsed;
  final double laborCost;
  final double partsCost;
  final double totalCost;
  final String status; // 'pending', 'in_progress', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<String>? beforePhotos;
  final List<String>? afterPhotos;
  final String? notes;

  ServiceOrder({
    required this.id,
    required this.vehicleId,
    required this.customerId,
    required this.serviceType,
    required this.description,
    this.partsUsed = const [],
    required this.laborCost,
    required this.partsCost,
    required this.totalCost,
    this.status = 'pending',
    required this.createdAt,
    this.completedAt,
    this.beforePhotos,
    this.afterPhotos,
    this.notes,
  });

  factory ServiceOrder.fromJson(Map<String, dynamic> json) {
    return ServiceOrder(
      id: json['id'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      customerId: json['customerId'] ?? '',
      serviceType: json['serviceType'] ?? '',
      description: json['description'] ?? '',
      partsUsed: json['partsUsed'] != null
          ? List<String>.from(json['partsUsed'])
          : [],
      laborCost: (json['laborCost'] ?? 0).toDouble(),
      partsCost: (json['partsCost'] ?? 0).toDouble(),
      totalCost: (json['totalCost'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      beforePhotos: json['beforePhotos'] != null
          ? List<String>.from(json['beforePhotos'])
          : null,
      afterPhotos: json['afterPhotos'] != null
          ? List<String>.from(json['afterPhotos'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'customerId': customerId,
      'serviceType': serviceType,
      'description': description,
      'partsUsed': partsUsed,
      'laborCost': laborCost,
      'partsCost': partsCost,
      'totalCost': totalCost,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'beforePhotos': beforePhotos,
      'afterPhotos': afterPhotos,
      'notes': notes,
    };
  }

  ServiceOrder copyWith({
    String? id,
    String? vehicleId,
    String? customerId,
    String? serviceType,
    String? description,
    List<String>? partsUsed,
    double? laborCost,
    double? partsCost,
    double? totalCost,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
    String? notes,
  }) {
    return ServiceOrder(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      partsUsed: partsUsed ?? this.partsUsed,
      laborCost: laborCost ?? this.laborCost,
      partsCost: partsCost ?? this.partsCost,
      totalCost: totalCost ?? this.totalCost,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      notes: notes ?? this.notes,
    );
  }
}

