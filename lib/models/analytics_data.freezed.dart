// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) {
  return _AnalyticsData.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsData {
  int get totalVehicles => throw _privateConstructorUsedError;
  int get totalCustomers => throw _privateConstructorUsedError;
  int get activeOrders => throw _privateConstructorUsedError;
  int get pendingOrders => throw _privateConstructorUsedError;
  int get completedOrders => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  double get monthlyRevenue => throw _privateConstructorUsedError;
  double get totalExpenses => throw _privateConstructorUsedError;
  double get monthlyExpenses => throw _privateConstructorUsedError;
  double get profitMargin => throw _privateConstructorUsedError;
  List<DailyRevenue> get dailyRevenue => throw _privateConstructorUsedError;
  List<ServiceTypeCount> get serviceTypeCounts =>
      throw _privateConstructorUsedError;
  List<MonthlyRevenue> get monthlyRevenueData =>
      throw _privateConstructorUsedError;

  /// Serializes this AnalyticsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDataCopyWith<AnalyticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDataCopyWith<$Res> {
  factory $AnalyticsDataCopyWith(
          AnalyticsData value, $Res Function(AnalyticsData) then) =
      _$AnalyticsDataCopyWithImpl<$Res, AnalyticsData>;
  @useResult
  $Res call(
      {int totalVehicles,
      int totalCustomers,
      int activeOrders,
      int pendingOrders,
      int completedOrders,
      double totalRevenue,
      double monthlyRevenue,
      double totalExpenses,
      double monthlyExpenses,
      double profitMargin,
      List<DailyRevenue> dailyRevenue,
      List<ServiceTypeCount> serviceTypeCounts,
      List<MonthlyRevenue> monthlyRevenueData});
}

/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res, $Val extends AnalyticsData>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalVehicles = null,
    Object? totalCustomers = null,
    Object? activeOrders = null,
    Object? pendingOrders = null,
    Object? completedOrders = null,
    Object? totalRevenue = null,
    Object? monthlyRevenue = null,
    Object? totalExpenses = null,
    Object? monthlyExpenses = null,
    Object? profitMargin = null,
    Object? dailyRevenue = null,
    Object? serviceTypeCounts = null,
    Object? monthlyRevenueData = null,
  }) {
    return _then(_value.copyWith(
      totalVehicles: null == totalVehicles
          ? _value.totalVehicles
          : totalVehicles // ignore: cast_nullable_to_non_nullable
              as int,
      totalCustomers: null == totalCustomers
          ? _value.totalCustomers
          : totalCustomers // ignore: cast_nullable_to_non_nullable
              as int,
      activeOrders: null == activeOrders
          ? _value.activeOrders
          : activeOrders // ignore: cast_nullable_to_non_nullable
              as int,
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyRevenue: null == monthlyRevenue
          ? _value.monthlyRevenue
          : monthlyRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyExpenses: null == monthlyExpenses
          ? _value.monthlyExpenses
          : monthlyExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      dailyRevenue: null == dailyRevenue
          ? _value.dailyRevenue
          : dailyRevenue // ignore: cast_nullable_to_non_nullable
              as List<DailyRevenue>,
      serviceTypeCounts: null == serviceTypeCounts
          ? _value.serviceTypeCounts
          : serviceTypeCounts // ignore: cast_nullable_to_non_nullable
              as List<ServiceTypeCount>,
      monthlyRevenueData: null == monthlyRevenueData
          ? _value.monthlyRevenueData
          : monthlyRevenueData // ignore: cast_nullable_to_non_nullable
              as List<MonthlyRevenue>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsDataImplCopyWith<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  factory _$$AnalyticsDataImplCopyWith(
          _$AnalyticsDataImpl value, $Res Function(_$AnalyticsDataImpl) then) =
      __$$AnalyticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalVehicles,
      int totalCustomers,
      int activeOrders,
      int pendingOrders,
      int completedOrders,
      double totalRevenue,
      double monthlyRevenue,
      double totalExpenses,
      double monthlyExpenses,
      double profitMargin,
      List<DailyRevenue> dailyRevenue,
      List<ServiceTypeCount> serviceTypeCounts,
      List<MonthlyRevenue> monthlyRevenueData});
}

/// @nodoc
class __$$AnalyticsDataImplCopyWithImpl<$Res>
    extends _$AnalyticsDataCopyWithImpl<$Res, _$AnalyticsDataImpl>
    implements _$$AnalyticsDataImplCopyWith<$Res> {
  __$$AnalyticsDataImplCopyWithImpl(
      _$AnalyticsDataImpl _value, $Res Function(_$AnalyticsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalVehicles = null,
    Object? totalCustomers = null,
    Object? activeOrders = null,
    Object? pendingOrders = null,
    Object? completedOrders = null,
    Object? totalRevenue = null,
    Object? monthlyRevenue = null,
    Object? totalExpenses = null,
    Object? monthlyExpenses = null,
    Object? profitMargin = null,
    Object? dailyRevenue = null,
    Object? serviceTypeCounts = null,
    Object? monthlyRevenueData = null,
  }) {
    return _then(_$AnalyticsDataImpl(
      totalVehicles: null == totalVehicles
          ? _value.totalVehicles
          : totalVehicles // ignore: cast_nullable_to_non_nullable
              as int,
      totalCustomers: null == totalCustomers
          ? _value.totalCustomers
          : totalCustomers // ignore: cast_nullable_to_non_nullable
              as int,
      activeOrders: null == activeOrders
          ? _value.activeOrders
          : activeOrders // ignore: cast_nullable_to_non_nullable
              as int,
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyRevenue: null == monthlyRevenue
          ? _value.monthlyRevenue
          : monthlyRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyExpenses: null == monthlyExpenses
          ? _value.monthlyExpenses
          : monthlyExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      dailyRevenue: null == dailyRevenue
          ? _value._dailyRevenue
          : dailyRevenue // ignore: cast_nullable_to_non_nullable
              as List<DailyRevenue>,
      serviceTypeCounts: null == serviceTypeCounts
          ? _value._serviceTypeCounts
          : serviceTypeCounts // ignore: cast_nullable_to_non_nullable
              as List<ServiceTypeCount>,
      monthlyRevenueData: null == monthlyRevenueData
          ? _value._monthlyRevenueData
          : monthlyRevenueData // ignore: cast_nullable_to_non_nullable
              as List<MonthlyRevenue>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDataImpl implements _AnalyticsData {
  const _$AnalyticsDataImpl(
      {this.totalVehicles = 0,
      this.totalCustomers = 0,
      this.activeOrders = 0,
      this.pendingOrders = 0,
      this.completedOrders = 0,
      this.totalRevenue = 0.0,
      this.monthlyRevenue = 0.0,
      this.totalExpenses = 0.0,
      this.monthlyExpenses = 0.0,
      this.profitMargin = 0.0,
      final List<DailyRevenue> dailyRevenue = const [],
      final List<ServiceTypeCount> serviceTypeCounts = const [],
      final List<MonthlyRevenue> monthlyRevenueData = const []})
      : _dailyRevenue = dailyRevenue,
        _serviceTypeCounts = serviceTypeCounts,
        _monthlyRevenueData = monthlyRevenueData;

  factory _$AnalyticsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDataImplFromJson(json);

  @override
  @JsonKey()
  final int totalVehicles;
  @override
  @JsonKey()
  final int totalCustomers;
  @override
  @JsonKey()
  final int activeOrders;
  @override
  @JsonKey()
  final int pendingOrders;
  @override
  @JsonKey()
  final int completedOrders;
  @override
  @JsonKey()
  final double totalRevenue;
  @override
  @JsonKey()
  final double monthlyRevenue;
  @override
  @JsonKey()
  final double totalExpenses;
  @override
  @JsonKey()
  final double monthlyExpenses;
  @override
  @JsonKey()
  final double profitMargin;
  final List<DailyRevenue> _dailyRevenue;
  @override
  @JsonKey()
  List<DailyRevenue> get dailyRevenue {
    if (_dailyRevenue is EqualUnmodifiableListView) return _dailyRevenue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyRevenue);
  }

  final List<ServiceTypeCount> _serviceTypeCounts;
  @override
  @JsonKey()
  List<ServiceTypeCount> get serviceTypeCounts {
    if (_serviceTypeCounts is EqualUnmodifiableListView)
      return _serviceTypeCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceTypeCounts);
  }

  final List<MonthlyRevenue> _monthlyRevenueData;
  @override
  @JsonKey()
  List<MonthlyRevenue> get monthlyRevenueData {
    if (_monthlyRevenueData is EqualUnmodifiableListView)
      return _monthlyRevenueData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyRevenueData);
  }

  @override
  String toString() {
    return 'AnalyticsData(totalVehicles: $totalVehicles, totalCustomers: $totalCustomers, activeOrders: $activeOrders, pendingOrders: $pendingOrders, completedOrders: $completedOrders, totalRevenue: $totalRevenue, monthlyRevenue: $monthlyRevenue, totalExpenses: $totalExpenses, monthlyExpenses: $monthlyExpenses, profitMargin: $profitMargin, dailyRevenue: $dailyRevenue, serviceTypeCounts: $serviceTypeCounts, monthlyRevenueData: $monthlyRevenueData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDataImpl &&
            (identical(other.totalVehicles, totalVehicles) ||
                other.totalVehicles == totalVehicles) &&
            (identical(other.totalCustomers, totalCustomers) ||
                other.totalCustomers == totalCustomers) &&
            (identical(other.activeOrders, activeOrders) ||
                other.activeOrders == activeOrders) &&
            (identical(other.pendingOrders, pendingOrders) ||
                other.pendingOrders == pendingOrders) &&
            (identical(other.completedOrders, completedOrders) ||
                other.completedOrders == completedOrders) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.monthlyRevenue, monthlyRevenue) ||
                other.monthlyRevenue == monthlyRevenue) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.monthlyExpenses, monthlyExpenses) ||
                other.monthlyExpenses == monthlyExpenses) &&
            (identical(other.profitMargin, profitMargin) ||
                other.profitMargin == profitMargin) &&
            const DeepCollectionEquality()
                .equals(other._dailyRevenue, _dailyRevenue) &&
            const DeepCollectionEquality()
                .equals(other._serviceTypeCounts, _serviceTypeCounts) &&
            const DeepCollectionEquality()
                .equals(other._monthlyRevenueData, _monthlyRevenueData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalVehicles,
      totalCustomers,
      activeOrders,
      pendingOrders,
      completedOrders,
      totalRevenue,
      monthlyRevenue,
      totalExpenses,
      monthlyExpenses,
      profitMargin,
      const DeepCollectionEquality().hash(_dailyRevenue),
      const DeepCollectionEquality().hash(_serviceTypeCounts),
      const DeepCollectionEquality().hash(_monthlyRevenueData));

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      __$$AnalyticsDataImplCopyWithImpl<_$AnalyticsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDataImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsData implements AnalyticsData {
  const factory _AnalyticsData(
      {final int totalVehicles,
      final int totalCustomers,
      final int activeOrders,
      final int pendingOrders,
      final int completedOrders,
      final double totalRevenue,
      final double monthlyRevenue,
      final double totalExpenses,
      final double monthlyExpenses,
      final double profitMargin,
      final List<DailyRevenue> dailyRevenue,
      final List<ServiceTypeCount> serviceTypeCounts,
      final List<MonthlyRevenue> monthlyRevenueData}) = _$AnalyticsDataImpl;

  factory _AnalyticsData.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDataImpl.fromJson;

  @override
  int get totalVehicles;
  @override
  int get totalCustomers;
  @override
  int get activeOrders;
  @override
  int get pendingOrders;
  @override
  int get completedOrders;
  @override
  double get totalRevenue;
  @override
  double get monthlyRevenue;
  @override
  double get totalExpenses;
  @override
  double get monthlyExpenses;
  @override
  double get profitMargin;
  @override
  List<DailyRevenue> get dailyRevenue;
  @override
  List<ServiceTypeCount> get serviceTypeCounts;
  @override
  List<MonthlyRevenue> get monthlyRevenueData;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyRevenue _$DailyRevenueFromJson(Map<String, dynamic> json) {
  return _DailyRevenue.fromJson(json);
}

/// @nodoc
mixin _$DailyRevenue {
  DateTime get date => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this DailyRevenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyRevenueCopyWith<DailyRevenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRevenueCopyWith<$Res> {
  factory $DailyRevenueCopyWith(
          DailyRevenue value, $Res Function(DailyRevenue) then) =
      _$DailyRevenueCopyWithImpl<$Res, DailyRevenue>;
  @useResult
  $Res call({DateTime date, double revenue});
}

/// @nodoc
class _$DailyRevenueCopyWithImpl<$Res, $Val extends DailyRevenue>
    implements $DailyRevenueCopyWith<$Res> {
  _$DailyRevenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyRevenueImplCopyWith<$Res>
    implements $DailyRevenueCopyWith<$Res> {
  factory _$$DailyRevenueImplCopyWith(
          _$DailyRevenueImpl value, $Res Function(_$DailyRevenueImpl) then) =
      __$$DailyRevenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double revenue});
}

/// @nodoc
class __$$DailyRevenueImplCopyWithImpl<$Res>
    extends _$DailyRevenueCopyWithImpl<$Res, _$DailyRevenueImpl>
    implements _$$DailyRevenueImplCopyWith<$Res> {
  __$$DailyRevenueImplCopyWithImpl(
      _$DailyRevenueImpl _value, $Res Function(_$DailyRevenueImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
  }) {
    return _then(_$DailyRevenueImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRevenueImpl implements _DailyRevenue {
  const _$DailyRevenueImpl({required this.date, required this.revenue});

  factory _$DailyRevenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRevenueImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double revenue;

  @override
  String toString() {
    return 'DailyRevenue(date: $date, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRevenueImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, revenue);

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRevenueImplCopyWith<_$DailyRevenueImpl> get copyWith =>
      __$$DailyRevenueImplCopyWithImpl<_$DailyRevenueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRevenueImplToJson(
      this,
    );
  }
}

abstract class _DailyRevenue implements DailyRevenue {
  const factory _DailyRevenue(
      {required final DateTime date,
      required final double revenue}) = _$DailyRevenueImpl;

  factory _DailyRevenue.fromJson(Map<String, dynamic> json) =
      _$DailyRevenueImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get revenue;

  /// Create a copy of DailyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyRevenueImplCopyWith<_$DailyRevenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServiceTypeCount _$ServiceTypeCountFromJson(Map<String, dynamic> json) {
  return _ServiceTypeCount.fromJson(json);
}

/// @nodoc
mixin _$ServiceTypeCount {
  String get serviceType => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this ServiceTypeCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceTypeCountCopyWith<ServiceTypeCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceTypeCountCopyWith<$Res> {
  factory $ServiceTypeCountCopyWith(
          ServiceTypeCount value, $Res Function(ServiceTypeCount) then) =
      _$ServiceTypeCountCopyWithImpl<$Res, ServiceTypeCount>;
  @useResult
  $Res call({String serviceType, int count});
}

/// @nodoc
class _$ServiceTypeCountCopyWithImpl<$Res, $Val extends ServiceTypeCount>
    implements $ServiceTypeCountCopyWith<$Res> {
  _$ServiceTypeCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceType = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceTypeCountImplCopyWith<$Res>
    implements $ServiceTypeCountCopyWith<$Res> {
  factory _$$ServiceTypeCountImplCopyWith(_$ServiceTypeCountImpl value,
          $Res Function(_$ServiceTypeCountImpl) then) =
      __$$ServiceTypeCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String serviceType, int count});
}

/// @nodoc
class __$$ServiceTypeCountImplCopyWithImpl<$Res>
    extends _$ServiceTypeCountCopyWithImpl<$Res, _$ServiceTypeCountImpl>
    implements _$$ServiceTypeCountImplCopyWith<$Res> {
  __$$ServiceTypeCountImplCopyWithImpl(_$ServiceTypeCountImpl _value,
      $Res Function(_$ServiceTypeCountImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceType = null,
    Object? count = null,
  }) {
    return _then(_$ServiceTypeCountImpl(
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceTypeCountImpl implements _ServiceTypeCount {
  const _$ServiceTypeCountImpl(
      {required this.serviceType, required this.count});

  factory _$ServiceTypeCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceTypeCountImplFromJson(json);

  @override
  final String serviceType;
  @override
  final int count;

  @override
  String toString() {
    return 'ServiceTypeCount(serviceType: $serviceType, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceTypeCountImpl &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, serviceType, count);

  /// Create a copy of ServiceTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceTypeCountImplCopyWith<_$ServiceTypeCountImpl> get copyWith =>
      __$$ServiceTypeCountImplCopyWithImpl<_$ServiceTypeCountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceTypeCountImplToJson(
      this,
    );
  }
}

abstract class _ServiceTypeCount implements ServiceTypeCount {
  const factory _ServiceTypeCount(
      {required final String serviceType,
      required final int count}) = _$ServiceTypeCountImpl;

  factory _ServiceTypeCount.fromJson(Map<String, dynamic> json) =
      _$ServiceTypeCountImpl.fromJson;

  @override
  String get serviceType;
  @override
  int get count;

  /// Create a copy of ServiceTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceTypeCountImplCopyWith<_$ServiceTypeCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyRevenue _$MonthlyRevenueFromJson(Map<String, dynamic> json) {
  return _MonthlyRevenue.fromJson(json);
}

/// @nodoc
mixin _$MonthlyRevenue {
  String get month => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  double get expenses => throw _privateConstructorUsedError;

  /// Serializes this MonthlyRevenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyRevenueCopyWith<MonthlyRevenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyRevenueCopyWith<$Res> {
  factory $MonthlyRevenueCopyWith(
          MonthlyRevenue value, $Res Function(MonthlyRevenue) then) =
      _$MonthlyRevenueCopyWithImpl<$Res, MonthlyRevenue>;
  @useResult
  $Res call({String month, double revenue, double expenses});
}

/// @nodoc
class _$MonthlyRevenueCopyWithImpl<$Res, $Val extends MonthlyRevenue>
    implements $MonthlyRevenueCopyWith<$Res> {
  _$MonthlyRevenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? revenue = null,
    Object? expenses = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyRevenueImplCopyWith<$Res>
    implements $MonthlyRevenueCopyWith<$Res> {
  factory _$$MonthlyRevenueImplCopyWith(_$MonthlyRevenueImpl value,
          $Res Function(_$MonthlyRevenueImpl) then) =
      __$$MonthlyRevenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String month, double revenue, double expenses});
}

/// @nodoc
class __$$MonthlyRevenueImplCopyWithImpl<$Res>
    extends _$MonthlyRevenueCopyWithImpl<$Res, _$MonthlyRevenueImpl>
    implements _$$MonthlyRevenueImplCopyWith<$Res> {
  __$$MonthlyRevenueImplCopyWithImpl(
      _$MonthlyRevenueImpl _value, $Res Function(_$MonthlyRevenueImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? revenue = null,
    Object? expenses = null,
  }) {
    return _then(_$MonthlyRevenueImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyRevenueImpl implements _MonthlyRevenue {
  const _$MonthlyRevenueImpl(
      {required this.month, required this.revenue, required this.expenses});

  factory _$MonthlyRevenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyRevenueImplFromJson(json);

  @override
  final String month;
  @override
  final double revenue;
  @override
  final double expenses;

  @override
  String toString() {
    return 'MonthlyRevenue(month: $month, revenue: $revenue, expenses: $expenses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyRevenueImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, month, revenue, expenses);

  /// Create a copy of MonthlyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyRevenueImplCopyWith<_$MonthlyRevenueImpl> get copyWith =>
      __$$MonthlyRevenueImplCopyWithImpl<_$MonthlyRevenueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyRevenueImplToJson(
      this,
    );
  }
}

abstract class _MonthlyRevenue implements MonthlyRevenue {
  const factory _MonthlyRevenue(
      {required final String month,
      required final double revenue,
      required final double expenses}) = _$MonthlyRevenueImpl;

  factory _MonthlyRevenue.fromJson(Map<String, dynamic> json) =
      _$MonthlyRevenueImpl.fromJson;

  @override
  String get month;
  @override
  double get revenue;
  @override
  double get expenses;

  /// Create a copy of MonthlyRevenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyRevenueImplCopyWith<_$MonthlyRevenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
