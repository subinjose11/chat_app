import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class BackupService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Backup all data to JSON
  static Future<File?> backupAllData() async {
    try {
      Map<String, dynamic> backup = {};

      // Backup vehicles
      final vehicles = await _firestore.collection('vehicles').get();
      backup['vehicles'] = vehicles.docs.map((doc) => doc.data()).toList();

      // Backup customers
      final customers = await _firestore.collection('customers').get();
      backup['customers'] = customers.docs.map((doc) => doc.data()).toList();

      // Backup service orders
      final orders = await _firestore.collection('service_orders').get();
      backup['service_orders'] = orders.docs.map((doc) => doc.data()).toList();

      // Backup payments
      final payments = await _firestore.collection('payments').get();
      backup['payments'] = payments.docs.map((doc) => doc.data()).toList();

      // Backup expenses
      final expenses = await _firestore.collection('expenses').get();
      backup['expenses'] = expenses.docs.map((doc) => doc.data()).toList();

      // Backup inventory
      final inventory = await _firestore.collection('inventory').get();
      backup['inventory'] = inventory.docs.map((doc) => doc.data()).toList();

      // Backup appointments
      final appointments = await _firestore.collection('appointments').get();
      backup['appointments'] = appointments.docs.map((doc) => doc.data()).toList();

      backup['backup_date'] = DateTime.now().toIso8601String();
      backup['version'] = '1.0.0';

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final filename = 'autotrack_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$filename');
      
      await file.writeAsString(jsonEncode(backup));
      
      return file;
    } catch (e) {
      print('Error creating backup: $e');
      return null;
    }
  }

  // Share backup file
  static Future<void> shareBackup(File backupFile) async {
    await Share.shareXFiles(
      [XFile(backupFile.path)],
      subject: 'RN Auto garage Backup - ${DateTime.now().toString().split(' ')[0]}',
    );
  }

  // Restore data from backup file
  static Future<bool> restoreFromBackup() async {
    try {
      // Let user pick backup file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        return false;
      }

      final file = File(result.files.single.path!);
      final contents = await file.readAsString();
      final Map<String, dynamic> backup = jsonDecode(contents);

      // Restore vehicles
      if (backup.containsKey('vehicles')) {
        for (var data in backup['vehicles']) {
          await _firestore.collection('vehicles').doc(data['id']).set(data);
        }
      }

      // Restore customers
      if (backup.containsKey('customers')) {
        for (var data in backup['customers']) {
          await _firestore.collection('customers').doc(data['id']).set(data);
        }
      }

      // Restore service orders
      if (backup.containsKey('service_orders')) {
        for (var data in backup['service_orders']) {
          await _firestore.collection('service_orders').doc(data['id']).set(data);
        }
      }

      // Restore payments
      if (backup.containsKey('payments')) {
        for (var data in backup['payments']) {
          await _firestore.collection('payments').doc(data['id']).set(data);
        }
      }

      // Restore expenses
      if (backup.containsKey('expenses')) {
        for (var data in backup['expenses']) {
          await _firestore.collection('expenses').doc(data['id']).set(data);
        }
      }

      // Restore inventory
      if (backup.containsKey('inventory')) {
        for (var data in backup['inventory']) {
          await _firestore.collection('inventory').doc(data['id']).set(data);
        }
      }

      // Restore appointments
      if (backup.containsKey('appointments')) {
        for (var data in backup['appointments']) {
          await _firestore.collection('appointments').doc(data['id']).set(data);
        }
      }

      return true;
    } catch (e) {
      print('Error restoring backup: $e');
      return false;
    }
  }

  // Export data to CSV
  static Future<File?> exportToCSV(String collectionName) async {
    try {
      final snapshot = await _firestore.collection(collectionName).get();
      
      if (snapshot.docs.isEmpty) return null;

      // Get headers from first document
      final headers = snapshot.docs.first.data().keys.toList();
      
      // Create CSV content
      StringBuffer csv = StringBuffer();
      csv.writeln(headers.join(','));

      for (var doc in snapshot.docs) {
        final values = headers.map((key) => doc.data()[key]?.toString() ?? '').toList();
        csv.writeln(values.join(','));
      }

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final filename = '${collectionName}_export_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${directory.path}/$filename');
      
      await file.writeAsString(csv.toString());
      
      return file;
    } catch (e) {
      print('Error exporting to CSV: $e');
      return null;
    }
  }
}

