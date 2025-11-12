import 'dart:io';
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
  // Generate Service Report PDF - Standard Billing Invoice
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
        margin: const pw.EdgeInsets.all(30),
        build: (context) => [
          // Company Header & Invoice Title
          _buildInvoiceHeader(order),
          pw.SizedBox(height: 15),

          // Bill To & Invoice Details Section
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              // Bill To
              pw.Expanded(
                child: _buildBillToSection(customer),
              ),
              pw.SizedBox(width: 15),
              // Invoice Details
              pw.Expanded(
                child: _buildInvoiceDetailsBox(order),
              ),
            ],
          ),
          pw.SizedBox(height: 12),

          // Vehicle Information Bar
          if (vehicle != null) _buildVehicleInfoBar(vehicle),
          if (vehicle != null) pw.SizedBox(height: 12),

          // Itemized Services & Parts Table
          _buildInvoiceTable(order),
          pw.SizedBox(height: 12),

          // Totals Section
          _buildTotalsSection(order),
          pw.SizedBox(height: 12),

          // Notes Section
          if ((order.notes != null && order.notes!.isNotEmpty) ||
              (order.mechanicNotes != null && order.mechanicNotes!.isNotEmpty))
            _buildNotesSection(order),

          if ((order.notes != null && order.notes!.isNotEmpty) ||
              (order.mechanicNotes != null && order.mechanicNotes!.isNotEmpty))
            pw.SizedBox(height: 12),

          // Payment Information
          if (payments != null && payments.isNotEmpty)
            _buildPaymentSection(payments),

          // Footer
          pw.Spacer(),
          _buildInvoiceFooter(),
        ],
      ),
    );

    return _savePdf(pdf, 'invoice_${order.id.substring(0, 8)}');
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
                  pw.Text(
                      'Date: ${DateFormat('MMM dd, yyyy').format(order.createdAt ?? DateTime.now())}'),
                  pw.Text('Status: ${order.status.toUpperCase()}'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('RN Auto garage',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.Text('Professional Auto Service'),
                  pw.Text('Phone: +1 234 567 890'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30),

          // Bill To
          if (customer != null) ...[
            pw.Text('Bill To:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text(customer.name),
            pw.Text(customer.phone),
            if (customer.email.isNotEmpty) pw.Text(customer.email),
            pw.SizedBox(height: 20),
          ],

          // Vehicle Info
          if (vehicle != null) ...[
            pw.Text('Vehicle:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text(
                '${vehicle.numberPlate} - ${vehicle.make} ${vehicle.model}'),
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
                  _buildTableCell(
                      '${order.serviceType}${order.description.isNotEmpty ? '\n${order.description}' : ''}'),
                  _buildTableCell(''),
                ],
              ),
              // Labor
              pw.TableRow(
                children: [
                  _buildTableCell('Labor'),
                  _buildTableCell('Rs. ${order.laborCost.toStringAsFixed(2)}'),
                ],
              ),
              // Parts
              pw.TableRow(
                children: [
                  _buildTableCell('Parts & Materials'),
                  _buildTableCell('Rs. ${order.partsCost.toStringAsFixed(2)}'),
                ],
              ),
              // Total
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('TOTAL', isHeader: true),
                  _buildTableCell('Rs. ${order.totalCost.toStringAsFixed(2)}',
                      isHeader: true),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30),

          // Payment Info
          if (payment != null) ...[
            pw.Text('Payment Information:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            _buildInfoRow('Method', payment.paymentMethod.toUpperCase()),
            _buildInfoRow('Status', payment.status.toUpperCase()),
            if (payment.transactionId != null)
              _buildInfoRow('Transaction ID', payment.transactionId!),
            pw.SizedBox(height: 20),
          ],

          // Notes
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            pw.Text('Notes:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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

  // NEW INVOICE TEMPLATE HELPERS

  // Build Professional Invoice Header
  static pw.Widget _buildInvoiceHeader(ServiceOrder order) {
    return pw.Column(
      children: [
        // Company Header Bar with Gradient
        pw.Container(
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            gradient: const pw.LinearGradient(
              colors: [PdfColors.blue900, PdfColors.blue700],
            ),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Company Info
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'RN AUTO GARAGE',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Professional Automotive Service & Repair Center',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Ph: +91 1234567890  |  Email: info@rnautogarage.com',
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Address: Your Business Address, City, State - PIN',
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Invoice Title and Status
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(4),
                      border: pw.Border.all(color: PdfColors.grey300, width: 1),
                    ),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build Bill To Section
  static pw.Widget _buildBillToSection(Customer? customer) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'BILL TO',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
              letterSpacing: 1,
            ),
          ),
          pw.SizedBox(height: 10),
          if (customer != null) ...[
            pw.Text(
              customer.name,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              customer.phone,
              style: const pw.TextStyle(fontSize: 11),
            ),
            if (customer.email.isNotEmpty) ...[
              pw.SizedBox(height: 2),
              pw.Text(
                customer.email,
                style: const pw.TextStyle(fontSize: 11),
              ),
            ],
            if (customer.address != null && customer.address!.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                customer.address!,
                style:
                    const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ],
          ] else ...[
            pw.Text(
              'Customer information not available',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey),
            ),
          ],
        ],
      ),
    );
  }

  // Build Invoice Details Box
  static pw.Widget _buildInvoiceDetailsBox(ServiceOrder order) {
    final invoiceDate = order.createdAt ?? DateTime.now();

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        border: pw.Border.all(color: PdfColors.blue900, width: 1.5),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 8),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
              ),
            ),
            child: pw.Text(
              'INVOICE DETAILS',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
                letterSpacing: 1,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          _buildDetailRow(
              'Invoice No:', 'INV-${order.id.substring(0, 8).toUpperCase()}',
              bold: true),
          pw.SizedBox(height: 7),
          _buildDetailRow(
              'Invoice Date:', DateFormat('dd MMM yyyy').format(invoiceDate)),
          pw.SizedBox(height: 7),
          if (order.completedAt != null) ...[
            _buildDetailRow('Completed:',
                DateFormat('dd MMM yyyy').format(order.completedAt!)),
            pw.SizedBox(height: 7),
          ],
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 7),
          _buildDetailRow('Service Type:', order.serviceType, bold: true),
          pw.SizedBox(height: 7),
          _buildDetailRow('Payment Status:', 'PAID', bold: true),
        ],
      ),
    );
  }

  // Build Vehicle Info Bar
  static pw.Widget _buildVehicleInfoBar(Vehicle vehicle) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              pw.Text(
                'Vehicle number: ',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                vehicle.numberPlate,
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ],
          ),
          pw.Text(
            '${vehicle.make} ${vehicle.model} (${vehicle.year})',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey800),
          ),
        ],
      ),
    );
  }

  // Build Invoice Table
  static pw.Widget _buildInvoiceTable(ServiceOrder order) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        // Header Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue900),
          children: [
            _buildTableHeaderCell('#'),
            _buildTableHeaderCell('DESCRIPTION'),
            _buildTableHeaderCell('QTY'),
            _buildTableHeaderCell('AMOUNT'),
          ],
        ),
        // Labor Row
        pw.TableRow(
          children: [
            _buildTableDataCell('1'),
            _buildTableDataCell(
                'Labor Charges\n${order.description.isNotEmpty ? order.description : order.serviceType}'),
            _buildTableDataCell('1'),
            _buildTableDataCell(order.laborCost.toStringAsFixed(2)),
          ],
        ),
        // Parts Rows
        ...order.parts.asMap().entries.map((entry) {
          final index = entry.key;
          final part = entry.value;
          return pw.TableRow(
            children: [
              _buildTableDataCell('${index + 2}'),
              _buildTableDataCell('Part: ${part.name}'),
              _buildTableDataCell('1'),
              _buildTableDataCell(part.cost.toStringAsFixed(2)),
            ],
          );
        }).toList(),
      ],
    );
  }

  // Build Totals Section
  static pw.Widget _buildTotalsSection(ServiceOrder order) {
    final total = order.totalCost;

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 280,
          padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue900,
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.blue900, width: 1.5),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'TOTAL AMOUNT',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 1,
                ),
              ),
              pw.Text(
                'Rs. ${total.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build Notes Section
  static pw.Widget _buildNotesSection(ServiceOrder order) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (order.notes != null && order.notes!.isNotEmpty) ...[
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CUSTOMER NOTES',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  order.notes!,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
        ],
        if (order.mechanicNotes != null && order.mechanicNotes!.isNotEmpty) ...[
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'MECHANIC NOTES',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  order.mechanicNotes!,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Build Payment Section
  static pw.Widget _buildPaymentSection(List<Payment> payments) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green300, width: 1),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'PAYMENT INFORMATION',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green900,
            ),
          ),
          pw.SizedBox(height: 8),
          ...payments.map((payment) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '${payment.paymentMethod.toUpperCase()} - ${payment.status.toUpperCase()}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      'Rs. ${payment.amount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // Build Invoice Footer
  static pw.Widget _buildInvoiceFooter() {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 8),
        // Terms & Thank You & Signature
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Terms
            pw.Expanded(
              flex: 3,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Terms & Conditions',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    '• All work guaranteed for 90 days\n• Parts covered under manufacturer warranty\n• Please inspect your vehicle before leaving',
                    style: const pw.TextStyle(
                        fontSize: 7, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 15),
            // Thank You
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'Thank you for your business!',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'For queries: +91 1234567890',
                    style: const pw.TextStyle(
                        fontSize: 7, color: PdfColors.grey600),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 15),
            // Signature
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.SizedBox(height: 20),
                  pw.Container(
                    width: double.infinity,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        top: pw.BorderSide(color: PdfColors.grey400, width: 1),
                      ),
                    ),
                    padding: const pw.EdgeInsets.only(top: 3),
                    child: pw.Text(
                      'Authorized Signature',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 7,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper: Build Detail Row
  static pw.Widget _buildDetailRow(String label, String value,
      {bool bold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Helper: Build Table Header Cell
  static pw.Widget _buildTableHeaderCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  // Helper: Build Table Data Cell
  static pw.Widget _buildTableDataCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  // OLD HELPERS (FOR generateInvoice method - kept for backward compatibility)

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

  // Helper: Build Info Row (for generateInvoice)
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
          'RN Auto garage - Professional Auto Service Management',
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
