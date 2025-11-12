import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/home/presentation/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(navIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.gray900 : AppColors.gray50,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    index: 0,
                    currentIndex: pageIndex,
                    onTap: () => ref.read(navIndexProvider.notifier).state = 0,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.directions_car_outlined,
                    activeIcon: Icons.directions_car_rounded,
                    label: 'Vehicles',
                    index: 1,
                    currentIndex: pageIndex,
                    onTap: () => ref.read(navIndexProvider.notifier).state = 1,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.receipt_long_outlined,
                    activeIcon: Icons.receipt_long_rounded,
                    label: 'Orders',
                    index: 2,
                    currentIndex: pageIndex,
                    onTap: () => ref.read(navIndexProvider.notifier).state = 2,
                    isDark: isDark,
                    isCenter: true,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.analytics_outlined,
                    activeIcon: Icons.analytics_rounded,
                    label: 'Reports',
                    index: 3,
                    currentIndex: pageIndex,
                    onTap: () => ref.read(navIndexProvider.notifier).state = 3,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings_rounded,
                    label: 'Settings',
                    index: 4,
                    currentIndex: pageIndex,
                    onTap: () => ref.read(navIndexProvider.notifier).state = 4,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
    required bool isDark,
    bool isCenter = false,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.primaryBlue.withOpacity(0.1),
          highlightColor: AppColors.primaryBlue.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container with animation
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0.0,
                    end: isSelected ? 1.0 : 0.0,
                  ),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 1.0 + (value * 0.12),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    AppColors.primaryBlue,
                                    AppColors.primaryBlue.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: !isSelected
                              ? (isDark
                                  ? AppColors.gray800.withOpacity(0.5)
                                  : AppColors.gray100)
                              : null,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color:
                                        AppColors.primaryBlue.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          isSelected ? activeIcon : icon,
                          size: 24,
                          color: isSelected
                              ? AppColors.white
                              : (isDark
                                  ? AppColors.gray400
                                  : AppColors.gray600),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                // Label with animation
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isSelected ? 11.5 : 10.5,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryBlue
                        : (isDark ? AppColors.gray500 : AppColors.gray600),
                    letterSpacing: 0.2,
                    height: 1.2,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
