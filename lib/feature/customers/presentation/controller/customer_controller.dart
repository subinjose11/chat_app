import 'package:chat_app/feature/customers/data/repository/customer_repository.dart';
import 'package:chat_app/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerController {
  final CustomerRepository customerRepository;

  CustomerController({required this.customerRepository});

  Future<void> createCustomer(BuildContext context, Customer customer) async {
    await customerRepository.createCustomer(context, customer);
  }

  Future<void> updateCustomer(BuildContext context, Customer customer) async {
    await customerRepository.updateCustomer(context, customer);
  }

  void deleteCustomer(BuildContext context, String customerId) {
    customerRepository.deleteCustomer(context, customerId);
  }

  Future<Customer?> getCustomer(String customerId) {
    return customerRepository.getCustomer(customerId);
  }
}

// Controller Provider
final customerControllerProvider = Provider((ref) {
  final customerRepository = ref.watch(customerRepositoryProvider);
  return CustomerController(customerRepository: customerRepository);
});

// Stream Provider for all customers
final customersStreamProvider = StreamProvider<List<Customer>>((ref) {
  final customerRepository = ref.watch(customerRepositoryProvider);
  return customerRepository.getCustomersStream();
});

// Stream Provider for single customer by ID
final customerStreamProvider = StreamProvider.family<Customer?, String>((ref, customerId) {
  final customerRepository = ref.watch(customerRepositoryProvider);
  return customerRepository.getCustomerStream(customerId);
});

// Search Provider
final customerSearchQueryProvider = StateProvider<String>((ref) => '');

final searchedCustomersProvider = StreamProvider<List<Customer>>((ref) {
  final query = ref.watch(customerSearchQueryProvider);
  final customerRepository = ref.watch(customerRepositoryProvider);
  return customerRepository.searchCustomers(query);
});

