class Vehicle {
  final String id;
  final String customerId;
  final String numberPlate;
  final String make;
  final String model;
  final String year;
  final String? fuelType;
  final String? vin;
  final String? color;
  final String? imageUrl;
  final DateTime? lastServiceDate;
  final String serviceStatus; // 'active', 'pending', 'completed'
  final int? mileage;

  Vehicle({
    required this.id,
    required this.customerId,
    required this.numberPlate,
    required this.make,
    required this.model,
    required this.year,
    this.fuelType,
    this.vin,
    this.color,
    this.imageUrl,
    this.lastServiceDate,
    this.serviceStatus = 'completed',
    this.mileage,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      numberPlate: json['numberPlate'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? '',
      fuelType: json['fuelType'],
      vin: json['vin'],
      color: json['color'],
      imageUrl: json['imageUrl'],
      lastServiceDate: json['lastServiceDate'] != null
          ? DateTime.parse(json['lastServiceDate'])
          : null,
      serviceStatus: json['serviceStatus'] ?? 'completed',
      mileage: json['mileage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'numberPlate': numberPlate,
      'make': make,
      'model': model,
      'year': year,
      'fuelType': fuelType,
      'vin': vin,
      'color': color,
      'imageUrl': imageUrl,
      'lastServiceDate': lastServiceDate?.toIso8601String(),
      'serviceStatus': serviceStatus,
      'mileage': mileage,
    };
  }

  Vehicle copyWith({
    String? id,
    String? customerId,
    String? numberPlate,
    String? make,
    String? model,
    String? year,
    String? fuelType,
    String? vin,
    String? color,
    String? imageUrl,
    DateTime? lastServiceDate,
    String? serviceStatus,
    int? mileage,
  }) {
    return Vehicle(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      numberPlate: numberPlate ?? this.numberPlate,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      fuelType: fuelType ?? this.fuelType,
      vin: vin ?? this.vin,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      mileage: mileage ?? this.mileage,
    );
  }
}

