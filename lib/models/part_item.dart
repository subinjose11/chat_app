import 'package:freezed_annotation/freezed_annotation.dart';

part 'part_item.freezed.dart';
part 'part_item.g.dart';

@freezed
class PartItem with _$PartItem {
  const factory PartItem({
    @Default('') String name,
    @Default(0.0) double cost,
    @Default(1) int quantity,
  }) = _PartItem;

  factory PartItem.fromJson(Map<String, dynamic> json) => _$PartItemFromJson(json);
}

