import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/feature/customers/presentation/controller/customer_controller.dart';
import 'package:chat_app/feature/vehicles/presentation/controller/vehicle_controller.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:chat_app/core/services/pdf_service.dart';
import 'package:chat_app/core/services/communication_service.dart';
import 'package:intl/intl.dart';

class ReportDetailScreen extends ConsumerStatefulWidget {
  final ServiceOrder serviceOrder;
  final Vehicle? vehicle;

  const ReportDetailScreen({
    super.key,
    required this.serviceOrder,
    this.vehicle,
  });

  @override
  ConsumerState<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends ConsumerState<ReportDetailScreen> {
  final _mechanicNotesController = TextEditingController();
  bool _isNotesModified = false;

  @override
  void initState() {
    super.initState();
    _mechanicNotesController.text = widget.serviceOrder.mechanicNotes ?? '';
    _mechanicNotesController.addListener(() {
      setState(() {
        _isNotesModified = _mechanicNotesController.text !=
            (widget.serviceOrder.mechanicNotes ?? '');
      });
    });
  }

  @override
  void dispose() {
    _mechanicNotesController.dispose();
    super.dispose();
  }

  Future<void> _saveMechanicNotes(ServiceOrder currentOrder) async {
    try {
      final updatedOrder = currentOrder.copyWith(
        mechanicNotes: _mechanicNotesController.text,
      );

      // Update in Firestore
      ref.read(serviceOrderControllerProvider).updateServiceOrder(
            context,
            updatedOrder,
          );

      setState(() {
        _isNotesModified = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mechanic notes saved successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving notes: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _shareReport(String method, ServiceOrder currentOrder) async {
    try {
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating PDF...')),
        );
      }

      // Fetch customer data
      final customer = await ref.read(
        customerStreamProvider(currentOrder.customerId).future,
      );

      // Fetch vehicle data if not provided
      Vehicle? vehicle = widget.vehicle;
      if (vehicle == null && currentOrder.vehicleId.isNotEmpty) {
        vehicle = await ref.read(
          vehicleStreamProvider(currentOrder.vehicleId).future,
        );
      }

      // Generate PDF
      final pdfFile = await PdfService.generateServiceReport(
        order: currentOrder,
        vehicle: vehicle,
        customer: customer,
      );

      // Share based on method
      if (method == 'Email') {
        await CommunicationService.sendEmail(
          email: '',
          subject: 'Service Report - ${currentOrder.id}',
          body: 'Please find attached the service report.',
        );
      } else if (method == 'WhatsApp') {
        await PdfService.sharePdf(pdfFile, 'Service Report');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shared via $method successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _generatePDF(ServiceOrder currentOrder) async {
    try {
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating PDF...')),
        );
      }

      // Fetch customer data
      final customer = await ref.read(
        customerStreamProvider(currentOrder.customerId).future,
      );

      // Fetch vehicle data if not provided
      Vehicle? vehicle = widget.vehicle;
      if (vehicle == null && currentOrder.vehicleId.isNotEmpty) {
        vehicle = await ref.read(
          vehicleStreamProvider(currentOrder.vehicleId).future,
        );
      }

      // Generate PDF
      final pdfFile = await PdfService.generateServiceReport(
        order: currentOrder,
        vehicle: vehicle,
        customer: customer,
      );

      // Share the PDF
      await PdfService.sharePdf(
        pdfFile,
        'Service Report - ${currentOrder.id.substring(0, 8)}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF generated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderAsync =
        ref.watch(serviceOrderStreamProvider(widget.serviceOrder.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Report'),
      ),
      body: orderAsync.when(
        data: (currentOrder) {
          if (currentOrder == null) {
            return const Center(child: Text('Order not found'));
          }

          // Update mechanic notes controller if the notes changed from external source
          if (_mechanicNotesController.text != currentOrder.mechanicNotes &&
              !_isNotesModified) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mechanicNotesController.text = currentOrder.mechanicNotes ?? '';
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.cardBackgroundDark : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          _getStatusColor(currentOrder.status).withOpacity(0.3),
                      width: 2,
                    ),
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
                  child: Row(
                    children: [
                      // Status Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getStatusColor(currentOrder.status)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getStatusIcon(currentOrder.status),
                          size: 32,
                          color: _getStatusColor(currentOrder.status),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Order Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${currentOrder.id.substring(0, 8)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.gray400
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentOrder.serviceType,
                              style: TextStyle(
                                fontSize: 18,
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
                                  Icons.calendar_today,
                                  size: 14,
                                  color: isDark
                                      ? AppColors.gray500
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  currentOrder.createdAt != null
                                      ? DateFormat('MMM dd, yyyy')
                                          .format(currentOrder.createdAt!)
                                      : 'N/A',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.gray400
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(currentOrder.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _formatStatus(currentOrder.status),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Information
                Consumer(
                  builder: (context, ref, child) {
                    final customerAsync = ref.watch(
                      customerStreamProvider(currentOrder.customerId),
                    );

                    return customerAsync.when(
                      data: (customer) {
                        if (customer == null) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            _buildInfoSection(
                              isDark,
                              'Customer Information',
                              [
                                _buildInfoRow(
                                    Icons.person, 'Name', customer.name),
                                _buildInfoRow(
                                    Icons.phone, 'Phone', customer.phone),
                                if (customer.email.isNotEmpty)
                                  _buildInfoRow(
                                      Icons.email, 'Email', customer.email),
                                if (customer.address != null &&
                                    customer.address!.isNotEmpty)
                                  _buildInfoRow(Icons.location_on, 'Address',
                                      customer.address!),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),

                // Vehicle Information
                Consumer(
                  builder: (context, ref, child) {
                    // Fetch vehicle if not provided
                    final vehicle = widget.vehicle ??
                        (currentOrder.vehicleId.isNotEmpty
                            ? ref
                                .watch(vehicleStreamProvider(
                                    currentOrder.vehicleId))
                                .value
                            : null);

                    return _buildInfoSection(
                      isDark,
                      'Vehicle Information',
                      [
                        _buildInfoRow(Icons.directions_car, 'Vehicle',
                            vehicle?.numberPlate ?? 'N/A'),
                        _buildInfoRow(Icons.car_repair, 'Model',
                            '${vehicle?.make ?? ''} ${vehicle?.model ?? ''}'),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Service Details
                _buildInfoSection(
                  isDark,
                  'Service Details',
                  [
                    _buildInfoRow(
                        Icons.build, 'Service Type', currentOrder.serviceType),
                    _buildInfoRow(
                        Icons.calendar_today,
                        'Date',
                        currentOrder.createdAt != null
                            ? DateFormat('MMM dd, yyyy')
                                .format(currentOrder.createdAt!)
                            : 'N/A'),
                    _buildInfoRow(Icons.description, 'Description',
                        currentOrder.description),
                    if (currentOrder.partsUsed.isNotEmpty)
                      _buildInfoRow(Icons.settings, 'Parts Used',
                          currentOrder.partsUsed.join(', ')),
                  ],
                ),
                const SizedBox(height: 16),

                // Cost Breakdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.cardBackgroundDark : AppColors.white,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cost Breakdown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Labor Breakdown
                      if (currentOrder.laborItems.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.engineering,
                                    size: 18, color: AppColors.gray500),
                                const SizedBox(width: 8),
                                Text(
                                  'Labor:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...currentOrder.laborItems
                            .map((labor) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, left: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.handyman,
                                              size: 16,
                                              color: AppColors.gray500),
                                          const SizedBox(width: 8),
                                          Text(
                                            labor.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark
                                                  ? AppColors.gray300
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '₹${labor.cost.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 4, bottom: 8),
                          child: Divider(height: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Labor:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '₹${currentOrder.laborItems.fold<double>(0, (sum, item) => sum + item.cost).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                      // Backward compatibility: show old labor cost if no labor items
                      else if (currentOrder.laborCost > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.engineering,
                                    size: 18, color: AppColors.gray500),
                                const SizedBox(width: 8),
                                Text(
                                  'Labor Cost',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹${currentOrder.laborCost.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Parts Breakdown
                      if (currentOrder.parts.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.build_circle,
                                    size: 18, color: AppColors.gray500),
                                const SizedBox(width: 8),
                                Text(
                                  'Parts & Materials:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...currentOrder.parts
                            .map((part) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, left: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.inventory_2_outlined,
                                                size: 16,
                                                color: AppColors.gray500),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${part.name} ${part.quantity > 1 ? 'x${part.quantity}' : ''}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: isDark
                                                      ? AppColors.gray300
                                                      : AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₹${(part.cost * part.quantity).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? AppColors.white
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                          if (part.quantity > 1)
                                            Text(
                                              '@ ₹${part.cost.toStringAsFixed(2)} each',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isDark
                                                    ? AppColors.gray400
                                                    : AppColors.textSecondary,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 4, bottom: 8),
                          child: Divider(height: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Parts:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '₹${currentOrder.partsCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const Divider(),
                      const SizedBox(height: 8),

                      // Total Cost
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.attach_money,
                                  size: 20, color: AppColors.gray500),
                              SizedBox(width: 12),
                              Text(
                                'Total Cost',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹${currentOrder.totalCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Photos
                if (currentOrder.beforePhotos.isNotEmpty ||
                    currentOrder.afterPhotos.isNotEmpty)
                  _buildPhotosSection(isDark, currentOrder),

                const SizedBox(height: 16),

                // Customer Notes
                if (currentOrder.notes != null &&
                    currentOrder.notes!.isNotEmpty)
                  _buildInfoSection(
                    isDark,
                    'Customer Notes',
                    [
                      Text(
                        currentOrder.notes!,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                if (currentOrder.notes != null &&
                    currentOrder.notes!.isNotEmpty)
                  const SizedBox(height: 16),

                // Mechanic Notes Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.cardBackgroundDark : AppColors.white,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.engineering,
                            size: 20,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Mechanic Notes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          if (_isNotesModified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit,
                                      size: 12, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Modified',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _mechanicNotesController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                              'Add technical notes, observations, or recommendations...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.gray800.withOpacity(0.3)
                              : AppColors.gray100,
                        ),
                      ),
                      if (_isNotesModified) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _mechanicNotesController.text =
                                        currentOrder.mechanicNotes ?? '';
                                    _isNotesModified = false;
                                  });
                                },
                                icon:
                                    const Icon(Icons.cancel_outlined, size: 18),
                                label: const Text('Cancel'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _saveMechanicNotes(currentOrder),
                                icon: const Icon(Icons.save, size: 18),
                                label: const Text('Save Notes'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _generatePDF(currentOrder),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Generate Invoice'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(bool isDark, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.gray500),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: valueStyle ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection(bool isDark, ServiceOrder currentOrder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Photos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (currentOrder.beforePhotos.isNotEmpty) ...[
          Text(
            'Before',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.gray400 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentOrder.beforePhotos.length,
              itemBuilder: (context, index) {
                return Container(
                  key: ValueKey('before_photo_$index'),
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(currentOrder.beforePhotos[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (currentOrder.afterPhotos.isNotEmpty) ...[
          Text(
            'After',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.gray400 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentOrder.afterPhotos.length,
              itemBuilder: (context, index) {
                return Container(
                  key: ValueKey('after_photo_$index'),
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(currentOrder.afterPhotos[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return const Color(0xFFFF9800); // Orange - Work in progress
      case 'pending':
        return const Color(0xFF2196F3); // Blue - Waiting to start
      case 'completed':
        return const Color(0xFF4CAF50); // Green - Work finished
      case 'delivered':
        return const Color(0xFF00C853); // Bright Green - Vehicle handed over
      case 'cancelled':
        return const Color(0xFFEF5350); // Red - Service cancelled
      default:
        return AppColors.gray500; // Gray - Unknown status
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_actions;
      case 'in_progress':
        return Icons.build_circle;
      case 'completed':
        return Icons.check_circle;
      case 'delivered':
        return Icons.local_shipping;
      default:
        return Icons.info;
    }
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
