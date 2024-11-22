import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider to control nav bar index
final navIndexProvider = StateProvider<int>((ref) => 0);
