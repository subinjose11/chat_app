// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsDataImpl _$$AnalyticsDataImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsDataImpl(
      totalVehicles: (json['totalVehicles'] as num?)?.toInt() ?? 0,
      totalCustomers: (json['totalCustomers'] as num?)?.toInt() ?? 0,
      activeOrders: (json['activeOrders'] as num?)?.toInt() ?? 0,
      pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completedOrders'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      monthlyExpenses: (json['monthlyExpenses'] as num?)?.toDouble() ?? 0.0,
      profitMargin: (json['profitMargin'] as num?)?.toDouble() ?? 0.0,
      dailyRevenue: (json['dailyRevenue'] as List<dynamic>?)
              ?.map((e) => DailyRevenue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      serviceTypeCounts: (json['serviceTypeCounts'] as List<dynamic>?)
              ?.map((e) => ServiceTypeCount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      monthlyRevenueData: (json['monthlyRevenueData'] as List<dynamic>?)
              ?.map((e) => MonthlyRevenue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AnalyticsDataImplToJson(_$AnalyticsDataImpl instance) =>
    <String, dynamic>{
      'totalVehicles': instance.totalVehicles,
      'totalCustomers': instance.totalCustomers,
      'activeOrders': instance.activeOrders,
      'pendingOrders': instance.pendingOrders,
      'completedOrders': instance.completedOrders,
      'totalRevenue': instance.totalRevenue,
      'monthlyRevenue': instance.monthlyRevenue,
      'totalExpenses': instance.totalExpenses,
      'monthlyExpenses': instance.monthlyExpenses,
      'profitMargin': instance.profitMargin,
      'dailyRevenue': instance.dailyRevenue,
      'serviceTypeCounts': instance.serviceTypeCounts,
      'monthlyRevenueData': instance.monthlyRevenueData,
    };

_$DailyRevenueImpl _$$DailyRevenueImplFromJson(Map<String, dynamic> json) =>
    _$DailyRevenueImpl(
      date: DateTime.parse(json['date'] as String),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailyRevenueImplToJson(_$DailyRevenueImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'revenue': instance.revenue,
    };

_$ServiceTypeCountImpl _$$ServiceTypeCountImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceTypeCountImpl(
      serviceType: json['serviceType'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$ServiceTypeCountImplToJson(
        _$ServiceTypeCountImpl instance) =>
    <String, dynamic>{
      'serviceType': instance.serviceType,
      'count': instance.count,
    };

_$MonthlyRevenueImpl _$$MonthlyRevenueImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyRevenueImpl(
      month: json['month'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
    );

Map<String, dynamic> _$$MonthlyRevenueImplToJson(
        _$MonthlyRevenueImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'revenue': instance.revenue,
      'expenses': instance.expenses,
    };
