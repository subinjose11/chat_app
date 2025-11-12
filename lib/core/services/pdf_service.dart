import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/models/customer.dart';
import 'package:chat_app/models/payment.dart';

class PdfService {
  // Generate Service Report PDF
  static Future<File> generateServiceReport({
    required ServiceOrder order,
    Vehicle? vehicle,
    Customer? customer,
    List<Payment>? payments,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          _buildHeader('SERVICE REPORT'),
          pw.SizedBox(height: 20),
          
          // Report Info
          _buildSectionTitle('Report Information'),
          _buildInfoRow('Report ID', order.id.substring(0, 8).toUpperCase()),
          _buildInfoRow('Date', DateFormat('MMM dd, yyyy').format(order.createdAt ?? DateTime.now())),
          _buildInfoRow('Status', order.status.toUpperCase()),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Customer Info
          if (customer != null) ...[
            _buildSectionTitle('Customer Information'),
            _buildInfoRow('Name', customer.name),
            _buildInfoRow('Phone', customer.phone),
            if (customer.email.isNotEmpty)
              _buildInfoRow('Email', customer.email),
            pw.Divider(),
            pw.SizedBox(height: 20),
          ],

          // Vehicle Info
          if (vehicle != null) ...[
            _buildSectionTitle('Vehicle Information'),
            _buildInfoRow('Registration', vehicle.numberPlate),
            _buildInfoRow('Make & Model', '${vehicle.make} ${vehicle.model}'),
            _buildInfoRow('Year', vehicle.year),
            if (vehicle.fuelType != null)
              _buildInfoRow('Fuel Type', vehicle.fuelType!),
            pw.Divider(),
            pw.SizedBox(height: 20),
          ],

          // Service Details
          _buildSectionTitle('Service Details'),
          _buildInfoRow('Service Type', order.serviceType),
          if (order.description.isNotEmpty)
            _buildInfoRow('Description', order.description),
          if (order.partsUsed.isNotEmpty)
            _buildInfoRow('Parts Used', order.partsUsed.join(', ')),
          if (order.notes != null && order.notes!.isNotEmpty)
            _buildInfoRow('Notes', order.notes!),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Cost Breakdown
          _buildSectionTitle('Cost Breakdown'),
          _buildCostRow('Labor Cost', order.laborCost),
          _buildCostRow('Parts Cost', order.partsCost),
          pw.Divider(),
          _buildTotalRow('Total Cost', order.totalCost),
          pw.SizedBox(height: 20),

          // Payment Info
          if (payments != null && payments.isNotEmpty) ...[
            _buildSectionTitle('Payment Information'),
            ...payments.map((payment) => 
              _buildInfoRow(
                'Payment (${payment.paymentMethod})',
                '₹${payment.amount.toStringAsFixed(2)} - ${payment.status}',
              ),
            ),
            pw.SizedBox(height: 20),
          ],

          // Footer
          pw.Spacer(),
          pw.Divider(),
          pw.SizedBox(height: 10),
          _buildFooter(),
        ],
      ),
    );

    return _savePdf(pdf, 'service_report_${order.id}');
  }

  // Generate Invoice PDF
  static Future<File> generateInvoice({
    required ServiceOrder order,
    Vehicle? vehicle,
    Customer? customer,
    Payment? payment,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          _buildHeader('INVOICE'),
          pw.SizedBox(height: 20),
          
          // Invoice Info
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Invoice #${order.id.substring(0, 8).toUpperCase()}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Date: ${DateFormat('MMM dd, yyyy').format(order.createdAt ?? DateTime.now())}'),
                  pw.Text('Status: ${order.status.toUpperCase()}'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('AutoTrack Pro',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.Text('Professional Auto Service'),
                  pw.Text('Phone: +1 234 567 890'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30),

          // Bill To
          if (customer != null) ...[
            pw.Text('Bill To:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text(customer.name),
            pw.Text(customer.phone),
            if (customer.email.isNotEmpty) pw.Text(customer.email),
            pw.SizedBox(height: 20),
          ],

          // Vehicle Info
          if (vehicle != null) ...[
            pw.Text('Vehicle:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text('${vehicle.numberPlate} - ${vehicle.make} ${vehicle.model}'),
            pw.SizedBox(height: 20),
          ],

          // Service Table
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _buildTableCell('Description', isHeader: true),
                  _buildTableCell('Amount', isHeader: true),
                ],
              ),
              // Service Type
              pw.TableRow(
                children: [
                  _buildTableCell('${order.serviceType}${order.description.isNotEmpty ? '\n${order.description}' : ''}'),
                  _buildTableCell(''),
                ],
              ),
              // Labor
              pw.TableRow(
                children: [
                  _buildTableCell('Labor'),
                  _buildTableCell('₹${order.laborCost.toStringAsFixed(2)}'),
                ],
              ),
              // Parts
              pw.TableRow(
                children: [
                  _buildTableCell('Parts & Materials'),
                  _buildTableCell('₹${order.partsCost.toStringAsFixed(2)}'),
                ],
              ),
              // Total
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('TOTAL', isHeader: true),
                  _buildTableCell('₹${order.totalCost.toStringAsFixed(2)}', isHeader: true),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30),

          // Payment Info
          if (payment != null) ...[
            pw.Text('Payment Information:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            _buildInfoRow('Method', payment.paymentMethod.toUpperCase()),
            _buildInfoRow('Status', payment.status.toUpperCase()),
            if (payment.transactionId != null)
              _buildInfoRow('Transaction ID', payment.transactionId!),
            pw.SizedBox(height: 20),
          ],

          // Notes
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            pw.Text('Notes:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text(order.notes!),
            pw.SizedBox(height: 20),
          ],

          // Footer
          pw.Spacer(),
          pw.Divider(),
          pw.SizedBox(height: 10),
          _buildFooter(),
        ],
      ),
    );

    return _savePdf(pdf, 'invoice_${order.id}');
  }

  // Helper: Build Header
  static pw.Widget _buildHeader(String title) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Container(
            width: 100,
            height: 3,
            color: PdfColors.blue,
          ),
        ],
      ),
    );
  }

  // Helper: Build Section Title
  static pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue900,
      ),
    );
  }

  // Helper: Build Info Row
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  // Helper: Build Cost Row
  static pw.Widget _buildCostRow(String label, double amount) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text('₹${amount.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  // Helper: Build Total Row
  static pw.Widget _buildTotalRow(String label, double amount) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            '₹${amount.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Build Table Cell
  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  // Helper: Build Footer
  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Text(
          'Thank you for your business!',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'AutoTrack Pro - Professional Auto Service Management',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
        ),
      ],
    );
  }

  // Save PDF to file
  static Future<File> _savePdf(pw.Document pdf, String filename) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$filename.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Share PDF
  static Future<void> sharePdf(File pdfFile, String subject) async {
    await Share.shareXFiles(
      [XFile(pdfFile.path)],
      subject: subject,
    );
  }

  // Print PDF
  static Future<void> printPdf(pw.Document pdf) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}

