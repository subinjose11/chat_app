import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:chat_app/feature/customers/presentation/controller/customer_controller.dart';
import 'package:chat_app/core/services/pdf_service.dart';
import 'package:chat_app/core/services/communication_service.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

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
  final _customerNotesController = TextEditingController();
  final _mechanicRemarksController = TextEditingController();
  
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.serviceOrder.status;
    _customerNotesController.text = widget.serviceOrder.notes ?? '';
  }

  @override
  void dispose() {
    _customerNotesController.dispose();
    _mechanicRemarksController.dispose();
    super.dispose();
  }

  void _updateStatus(String newStatus) {
    setState(() => _currentStatus = newStatus);
    ref.read(serviceOrderControllerProvider).updateServiceOrderStatus(
      context,
      widget.serviceOrder.id,
      newStatus,
    );
  }

  Future<void> _shareReport(String method) async {
    try {
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating PDF...')),
        );
      }

      // Generate PDF
      final pdfFile = await PdfService.generateServiceReport(
        order: widget.serviceOrder,
        vehicle: widget.vehicle,
      );

      // Share based on method
      if (method == 'Email') {
        await CommunicationService.sendEmail(
          email: '',
          subject: 'Service Report - ${widget.serviceOrder.id}',
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

  Future<void> _generatePDF() async {
    try {
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating PDF...')),
        );
      }

      // Generate PDF
      final pdfFile = await PdfService.generateServiceReport(
        order: widget.serviceOrder,
        vehicle: widget.vehicle,
      );

      // Share the PDF
      await PdfService.sharePdf(
        pdfFile,
        'Service Report - ${widget.serviceOrder.id.substring(0, 8)}',
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/service-order', extra: widget.vehicle);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showShareOptions(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getStatusColor(_currentStatus),
                    _getStatusColor(_currentStatus).withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    _getStatusIcon(_currentStatus),
                    size: 48,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentStatus.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Service Order #${widget.serviceOrder.id.substring(0, 8)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Customer Information
            Consumer(
              builder: (context, ref, child) {
                final customerAsync = ref.watch(
                  customerStreamProvider(widget.serviceOrder.customerId),
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
                            _buildInfoRow(Icons.person, 'Name', customer.name),
                            _buildInfoRow(Icons.phone, 'Phone', customer.phone),
                            if (customer.email.isNotEmpty)
                              _buildInfoRow(Icons.email, 'Email', customer.email),
                            if (customer.address != null && customer.address!.isNotEmpty)
                              _buildInfoRow(Icons.location_on, 'Address', customer.address!),
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
            _buildInfoSection(
              isDark,
              'Vehicle Information',
              [
                _buildInfoRow(Icons.directions_car, 'Vehicle', widget.vehicle?.numberPlate ?? 'N/A'),
                _buildInfoRow(Icons.car_repair, 'Model', '${widget.vehicle?.make ?? ''} ${widget.vehicle?.model ?? ''}'),
              ],
            ),
            const SizedBox(height: 16),

            // Service Details
            _buildInfoSection(
              isDark,
              'Service Details',
              [
                _buildInfoRow(Icons.build, 'Service Type', widget.serviceOrder.serviceType),
                _buildInfoRow(Icons.calendar_today, 'Date', 
                  widget.serviceOrder.createdAt != null 
                    ? DateFormat('MMM dd, yyyy').format(widget.serviceOrder.createdAt!)
                    : 'N/A'),
                _buildInfoRow(Icons.description, 'Description', widget.serviceOrder.description),
                if (widget.serviceOrder.partsUsed.isNotEmpty)
                  _buildInfoRow(Icons.settings, 'Parts Used', widget.serviceOrder.partsUsed.join(', ')),
              ],
            ),
            const SizedBox(height: 16),

            // Cost Breakdown
            Container(
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
                    'Cost Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Labor Cost
                  _buildInfoRow(Icons.engineering, 'Labor Cost', '\$${widget.serviceOrder.laborCost.toStringAsFixed(2)}'),
                  
                  // Parts Breakdown
                  if (widget.serviceOrder.parts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Parts:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...widget.serviceOrder.parts.map((part) => Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.build_circle, size: 16, color: AppColors.gray500),
                              const SizedBox(width: 8),
                              Text(
                                part.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.gray300 : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${part.cost.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.white : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                    const Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
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
                              color: isDark ? AppColors.white : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '\$${widget.serviceOrder.partsCost.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.white : AppColors.textPrimary,
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
                          Icon(Icons.attach_money, size: 20, color: AppColors.gray500),
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
                        '\$${widget.serviceOrder.totalCost.toStringAsFixed(2)}',
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
            if (widget.serviceOrder.beforePhotos.isNotEmpty || widget.serviceOrder.afterPhotos.isNotEmpty)
              _buildPhotosSection(isDark),
            
            const SizedBox(height: 16),

            // Customer Notes
            Text(
              'Customer Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _customerNotesController,
              decoration: const InputDecoration(
                hintText: 'Add customer notes...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Mechanic Remarks
            Text(
              'Mechanic Remarks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _mechanicRemarksController,
              decoration: const InputDecoration(
                hintText: 'Add mechanic remarks...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Update Status Section
            Text(
              'Update Service Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatusChip('pending', 'Pending'),
                _buildStatusChip('in_progress', 'In Progress'),
                _buildStatusChip('completed', 'Completed'),
                _buildStatusChip('delivered', 'Delivered'),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showShareOptions(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generatePDF,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate PDF'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
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

  Widget _buildInfoRow(IconData icon, String label, String value, {TextStyle? valueStyle}) {
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
                  style: valueStyle ?? const TextStyle(
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

  Widget _buildPhotosSection(bool isDark) {
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
        if (widget.serviceOrder.beforePhotos.isNotEmpty) ...[
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
              itemCount: widget.serviceOrder.beforePhotos.length,
              itemBuilder: (context, index) {
                return Container(
                  key: ValueKey('before_photo_$index'),
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(widget.serviceOrder.beforePhotos[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (widget.serviceOrder.afterPhotos.isNotEmpty) ...[
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
              itemCount: widget.serviceOrder.afterPhotos.length,
              itemBuilder: (context, index) {
                return Container(
                  key: ValueKey('after_photo_$index'),
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(widget.serviceOrder.afterPhotos[index]),
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

  Widget _buildStatusChip(String status, String label) {
    final isSelected = _currentStatus == status;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _updateStatus(status);
        }
      },
      selectedColor: _getStatusColor(status).withOpacity(0.2),
      checkmarkColor: _getStatusColor(status),
      labelStyle: TextStyle(
        color: isSelected ? _getStatusColor(status) : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'in_progress':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'delivered':
        return AppColors.primaryBlue;
      default:
        return AppColors.gray500;
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

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Share Report',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.file_download, color: AppColors.primaryBlue),
                title: const Text('Download PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _generatePDF();
                },
              ),
              ListTile(
                leading: const Icon(Icons.email, color: AppColors.info),
                title: const Text('Share via Email'),
                onTap: () {
                  Navigator.pop(context);
                  _shareReport('Email');
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: AppColors.success),
                title: const Text('Share via WhatsApp'),
                onTap: () {
                  Navigator.pop(context);
                  _shareReport('WhatsApp');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

