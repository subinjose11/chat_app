class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? address;
  final DateTime createdAt;
  final List<String> vehicleIds;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    required this.createdAt,
    this.vehicleIds = const [],
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      vehicleIds: json['vehicleIds'] != null 
          ? List<String>.from(json['vehicleIds'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'vehicleIds': vehicleIds,
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    DateTime? createdAt,
    List<String>? vehicleIds,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      vehicleIds: vehicleIds ?? this.vehicleIds,
    );
  }
}

