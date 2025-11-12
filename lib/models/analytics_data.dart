import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_data.freezed.dart';
part 'analytics_data.g.dart';

@freezed
class AnalyticsData with _$AnalyticsData {
  const factory AnalyticsData({
    @Default(0) int totalVehicles,
    @Default(0) int totalCustomers,
    @Default(0) int activeOrders,
    @Default(0) int pendingOrders,
    @Default(0) int completedOrders,
    @Default(0.0) double totalRevenue,
    @Default(0.0) double monthlyRevenue,
    @Default(0.0) double totalExpenses,
    @Default(0.0) double monthlyExpenses,
    @Default(0.0) double profitMargin,
    @Default([]) List<DailyRevenue> dailyRevenue,
    @Default([]) List<ServiceTypeCount> serviceTypeCounts,
    @Default([]) List<MonthlyRevenue> monthlyRevenueData,
  }) = _AnalyticsData;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);
}

@freezed
class DailyRevenue with _$DailyRevenue {
  const factory DailyRevenue({
    required DateTime date,
    required double revenue,
  }) = _DailyRevenue;

  factory DailyRevenue.fromJson(Map<String, dynamic> json) =>
      _$DailyRevenueFromJson(json);
}

@freezed
class ServiceTypeCount with _$ServiceTypeCount {
  const factory ServiceTypeCount({
    required String serviceType,
    required int count,
  }) = _ServiceTypeCount;

  factory ServiceTypeCount.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeCountFromJson(json);
}

@freezed
class MonthlyRevenue with _$MonthlyRevenue {
  const factory MonthlyRevenue({
    required String month,
    required double revenue,
    required double expenses,
  }) = _MonthlyRevenue;

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) =>
      _$MonthlyRevenueFromJson(json);
}

