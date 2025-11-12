import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final int vehicleCount;
  final VoidCallback? onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    this.vehicleCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black26 
                  : AppColors.gray300.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: Text(
                  customer.name.isNotEmpty 
                      ? customer.name[0].toUpperCase() 
                      : '?',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Customer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark 
                            ? AppColors.white 
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14,
                          color: isDark 
                              ? AppColors.gray500 
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.phone,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark 
                                ? AppColors.gray400 
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (customer.email.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            size: 14,
                            color: isDark 
                                ? AppColors.gray500 
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              customer.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark 
                                    ? AppColors.gray400 
                                    : AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          size: 14,
                          color: isDark 
                              ? AppColors.gray500 
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$vehicleCount ${vehicleCount == 1 ? 'Vehicle' : 'Vehicles'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark 
                                ? AppColors.gray500 
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.gray500 : AppColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

