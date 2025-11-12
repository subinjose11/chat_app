import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chat_app/models/part_item.dart';
import 'dart:developer';

class PartItemListConverter implements JsonConverter<List<PartItem>, List<dynamic>?> {
  const PartItemListConverter();

  @override
  List<PartItem> fromJson(List<dynamic>? json) {
    if (json == null || json.isEmpty) {
      return [];
    }
    
    try {
      return json.map((e) {
        if (e is Map<String, dynamic>) {
          return PartItem.fromJson(e);
        } else if (e is Map) {
          // Convert Map to Map<String, dynamic>
          return PartItem.fromJson(Map<String, dynamic>.from(e));
        } else {
          log('Warning: Invalid part item data: $e');
          return null;
        }
      }).whereType<PartItem>().toList();
    } catch (e) {
      log('Error converting parts from JSON: $e');
      return [];
    }
  }

  @override
  List<dynamic> toJson(List<PartItem> parts) {
    try {
      return parts.map((e) => e.toJson()).toList();
    } catch (e) {
      log('Error converting parts to JSON: $e');
      return [];
    }
  }
}

