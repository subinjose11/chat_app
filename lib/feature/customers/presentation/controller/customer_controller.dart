import 'package:chat_app/feature/customers/data/repository/customer_repository.dart';
import 'package:chat_app/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerController {
  final CustomerRepository customerRepository;

  CustomerController({required this.customerRepository});

  void createCustomer(BuildContext context, Customer customer) {
    customerRepository.createCustomer(context, customer);
  }

  void updateCustomer(BuildContext context, Customer customer) {
    customerRepository.updateCustomer(context, customer);
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

// Search Provider
final customerSearchQueryProvider = StateProvider<String>((ref) => '');

final searchedCustomersProvider = StreamProvider<List<Customer>>((ref) {
  final query = ref.watch(customerSearchQueryProvider);
  final customerRepository = ref.watch(customerRepositoryProvider);
  return customerRepository.searchCustomers(query);
});

