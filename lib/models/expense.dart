import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
class Expense with _$Expense {
  const factory Expense({
    @Default('') String id,
    required String category, // rent, utilities, salaries, parts, tools, misc
    required String description,
    required double amount,
    String? receiptUrl,
    String? vendor,
    DateTime? expenseDate,
    DateTime? createdAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}

