import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/widget/customer_card.dart';
import 'package:chat_app/core/widget/empty_state.dart';
import 'package:chat_app/models/customer.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample data - replace with actual data from backend
  final List<Customer> _sampleCustomers = [
    Customer(
      id: 'c1',
      name: 'John Smith',
      phone: '+1 234-567-8900',
      email: 'john.smith@email.com',
      address: '123 Main St, City, State 12345',
      createdAt: DateTime(2024, 1, 15),
      vehicleIds: ['v1', 'v2'],
    ),
    Customer(
      id: 'c2',
      name: 'Sarah Johnson',
      phone: '+1 234-567-8901',
      email: 'sarah.j@email.com',
      address: '456 Oak Ave, City, State 12345',
      createdAt: DateTime(2024, 2, 20),
      vehicleIds: ['v3'],
    ),
    Customer(
      id: 'c3',
      name: 'Michael Brown',
      phone: '+1 234-567-8902',
      email: 'mbrown@email.com',
      address: '789 Pine Rd, City, State 12345',
      createdAt: DateTime(2024, 3, 10),
      vehicleIds: ['v4', 'v5', 'v6'],
    ),
    Customer(
      id: 'c4',
      name: 'Emily Davis',
      phone: '+1 234-567-8903',
      email: 'emily.davis@email.com',
      address: '321 Elm St, City, State 12345',
      createdAt: DateTime(2024, 4, 5),
      vehicleIds: ['v7'],
    ),
  ];

  List<Customer> get _filteredCustomers {
    if (_searchQuery.isEmpty) return _sampleCustomers;
    
    return _sampleCustomers.where((customer) {
      final query = _searchQuery.toLowerCase();
      return customer.name.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortOptions(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark
                ? AppColors.scaffoldBackgroundDark
                : AppColors.scaffoldBackgroundLight,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name, phone, or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Customer Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              '${_filteredCustomers.length} ${_filteredCustomers.length == 1 ? 'Customer' : 'Customers'}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.gray400 : AppColors.textSecondary,
              ),
            ),
          ),

          // Customer List
          Expanded(
            child: _filteredCustomers.isEmpty
                ? EmptyState(
                    icon: Icons.people_outline,
                    title: 'No Customers Found',
                    message: _searchQuery.isNotEmpty
                        ? 'Try adjusting your search'
                        : 'Start by adding your first customer',
                    actionLabel: _searchQuery.isEmpty ? 'Add Customer' : null,
                    onAction: _searchQuery.isEmpty
                        ? () {
                            // TODO: Navigate to add customer
                          }
                        : null,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      return CustomerCard(
                        customer: customer,
                        vehicleCount: customer.vehicleIds.length,
                        onTap: () {
                          _showCustomerDetails(context, customer);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddCustomerDialog(context);
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Customer'),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Name (A-Z)'),
                onTap: () {
                  setState(() {
                    _sampleCustomers.sort((a, b) => a.name.compareTo(b.name));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date Added (Newest)'),
                onTap: () {
                  setState(() {
                    _sampleCustomers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text('Vehicle Count'),
                onTap: () {
                  setState(() {
                    _sampleCustomers.sort((a, b) => 
                        b.vehicleIds.length.compareTo(a.vehicleIds.length));
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomerDetails(BuildContext context, Customer customer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollController,
                children: [
                  // Customer Avatar and Name
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                          child: Text(
                            customer.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          customer.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Contact Information
                  _buildDetailRow(Icons.phone, 'Phone', customer.phone),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.email, 'Email', customer.email),
                  if (customer.address != null) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.location_on, 'Address', customer.address!),
                  ],
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    Icons.directions_car,
                    'Vehicles',
                    '${customer.vehicleIds.length} ${customer.vehicleIds.length == 1 ? 'Vehicle' : 'Vehicles'}',
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Call customer
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Email customer
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: View customer vehicles
                    },
                    icon: const Icon(Icons.directions_car),
                    label: const Text('View Vehicles'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.gray500),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Customer'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address (Optional)',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // TODO: Save customer to backend
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Customer added successfully!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

