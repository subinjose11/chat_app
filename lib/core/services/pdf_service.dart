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
import 'package:chat_app/models/part_item.dart';

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
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          // Company Header & Invoice Title
          _buildInvoiceHeader(order),
          pw.SizedBox(height: 8),

          // Bill To & Invoice Details Section
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              // Bill To
              pw.Expanded(
                child: _buildBillToSection(customer),
              ),
              pw.SizedBox(width: 10),
              // Invoice Details
              pw.Expanded(
                child: _buildInvoiceDetailsBox(order),
              ),
            ],
          ),
          pw.SizedBox(height: 8),

          // Vehicle Information Bar
          if (vehicle != null) _buildVehicleInfoBar(vehicle, kmRun: order.kmRun),
          if (vehicle != null) pw.SizedBox(height: 8),

          // Itemized Services & Parts Table
          _buildInvoiceTable(order),
          pw.SizedBox(height: 8),

          // Customer Notes Section (before totals)
          if (order.notes != null && order.notes!.isNotEmpty)
            _buildCustomerNotesSection(order),

          if (order.notes != null && order.notes!.isNotEmpty)
            pw.SizedBox(height: 8),

          // Totals Section
          _buildTotalsSection(order),
          pw.SizedBox(height: 8),

          // Mechanic Notes Section (after totals)
          if (order.mechanicNotes != null && order.mechanicNotes!.isNotEmpty)
            _buildMechanicNotesSection(order),

          if (order.mechanicNotes != null && order.mechanicNotes!.isNotEmpty)
            pw.SizedBox(height: 8),

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


  // NEW INVOICE TEMPLATE HELPERS

  // Build Professional Invoice Header
  static pw.Widget _buildInvoiceHeader(ServiceOrder order) {
    return pw.Column(
      children: [
        // Company Header Bar with Gradient
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
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
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Professional Automotive Service & Repair Center',
                      style: const pw.TextStyle(
                        fontSize: 7,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Ph: +91 80152 52501  |  Email: regisudhakar@gmail.com',
                      style: const pw.TextStyle(
                        fontSize: 7,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 1),
                    pw.Text(
                      'Address: Karanampettai, Tirupur, Tamil Nadu',
                      style: const pw.TextStyle(
                        fontSize: 7,
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
                        horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(4),
                      border: pw.Border.all(color: PdfColors.grey300, width: 1),
                    ),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 12,
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
      padding: const pw.EdgeInsets.all(10),
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
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
              letterSpacing: 1,
            ),
          ),
          pw.SizedBox(height: 6),
          if (customer != null) ...[
            pw.Text(
              customer.name,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              customer.phone,
              style: const pw.TextStyle(fontSize: 9),
            ),
            if (customer.email.isNotEmpty) ...[
              pw.SizedBox(height: 1),
              pw.Text(
                customer.email,
                style: const pw.TextStyle(fontSize: 9),
              ),
            ],
            if (customer.address != null && customer.address!.isNotEmpty) ...[
              pw.SizedBox(height: 2),
              pw.Text(
                customer.address!,
                style:
                    const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
              ),
            ],
          ] else ...[
            pw.Text(
              'Customer information not available',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
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
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        border: pw.Border.all(color: PdfColors.grey400, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 6),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
              ),
            ),
            child: pw.Text(
              'INVOICE DETAILS',
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
                letterSpacing: 1,
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          _buildDetailRow(
              'Invoice No:', 'INV-${order.id.substring(0, 8).toUpperCase()}',
              bold: true),
          pw.SizedBox(height: 4),
          _buildDetailRow(
              'Invoice Date:', DateFormat('dd MMM yyyy').format(invoiceDate)),
          pw.SizedBox(height: 4),
          if (order.completedAt != null) ...[
            _buildDetailRow('Completed:',
                DateFormat('dd MMM yyyy').format(order.completedAt!)),
            pw.SizedBox(height: 4),
          ],
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 7),
          _buildDetailRow('Service Type:', order.serviceType, bold: true),
        ],
      ),
    );
  }

  // Build Vehicle Info Bar
  static pw.Widget _buildVehicleInfoBar(Vehicle vehicle, {int? kmRun}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
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
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                vehicle.numberPlate,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              if (kmRun != null) ...[
                pw.SizedBox(width: 16),
                pw.Text(
                  'KM Run: ',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '$kmRun km',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ],
            ],
          ),
          pw.Text(
            '${vehicle.make} ${vehicle.model} (${vehicle.year})',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
          ),
        ],
      ),
    );
  }

  // Build Invoice Table
  static pw.Widget _buildInvoiceTable(ServiceOrder order) {
    // Calculate totals
    final partsSubTotal = order.parts
        .fold<double>(0, (sum, part) => sum + (part.cost * part.quantity));

    // For backward compatibility: use laborItems if available, else use laborCost
    final laborItems = order.laborItems.isNotEmpty
        ? order.laborItems
        : (order.laborCost > 0
            ? [
                const PartItem(name: 'Labor Charges', cost: 0.0)
                    .copyWith(cost: order.laborCost)
              ]
            : <PartItem>[]);

    final servicesSubTotal =
        laborItems.fold<double>(0, (sum, item) => sum + item.cost);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // SPARE PARTS SECTION
        if (order.parts.isNotEmpty) ...[
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            child: pw.Center(
              child: pw.Text(
                'Spare Parts',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
            },
            children: [
              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  _buildTableHeaderCell('S.no', color: PdfColors.black),
                  _buildTableHeaderCell('Item', color: PdfColors.black),
                  _buildTableHeaderCell('Qty', color: PdfColors.black),
                  _buildTableHeaderCell('Rate (INR)', color: PdfColors.black),
                  _buildTableHeaderCell('Price (INR)', color: PdfColors.black),
                ],
              ),
              // Parts Rows
              ...order.parts.asMap().entries.map((entry) {
                final index = entry.key;
                final part = entry.value;
                final totalPrice = part.cost * part.quantity;
                return pw.TableRow(
                  children: [
                    _buildTableDataCell('${index + 1}', isPrice: true),
                    _buildTableDataCell(part.name),
                    _buildTableDataCell('${part.quantity}', isPrice: true),
                    _buildTableDataCell(part.cost.toStringAsFixed(0),
                        isPrice: true),
                    _buildTableDataCell(totalPrice.toStringAsFixed(0),
                        isPrice: true),
                  ],
                );
              }).toList(),
              // Sub Total Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _buildTableDataCell(''),
                  _buildTableDataCell(''),
                  _buildTableDataCell(''),
                  _buildTableDataCell('Spare Parts Sub Total',
                      bold: true, alignment: pw.Alignment.centerRight),
                  _buildTableDataCell(partsSubTotal.toStringAsFixed(0),
                      bold: true, isPrice: true),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
        ],

        // SERVICES SECTION
        if (laborItems.isNotEmpty) ...[
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            child: pw.Center(
              child: pw.Text(
                'Services',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  _buildTableHeaderCell('S.no', color: PdfColors.black),
                  _buildTableHeaderCell('Item', color: PdfColors.black),
                  _buildTableHeaderCell('Price (INR)', color: PdfColors.black),
                ],
              ),
              // Service Rows
              ...laborItems.asMap().entries.map((entry) {
                final index = entry.key;
                final labor = entry.value;
                return pw.TableRow(
                  children: [
                    _buildTableDataCell('${index + 1}', isPrice: true),
                    _buildTableDataCell(labor.name),
                    _buildTableDataCell(labor.cost.toStringAsFixed(0),
                        isPrice: true),
                  ],
                );
              }).toList(),
              // Services Sub Total Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _buildTableDataCell(''),
                  _buildTableDataCell('Services Sub Total',
                      bold: true, alignment: pw.Alignment.centerRight),
                  _buildTableDataCell(servicesSubTotal.toStringAsFixed(0),
                      bold: true, isPrice: true),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Build Totals Section - Professional Right-Aligned Table
  static pw.Widget _buildTotalsSection(ServiceOrder order) {
    final grandTotal = order.totalCost;
    final advancePaid = order.advancePaid;
    final balanceAmount = grandTotal - advancePaid;

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
          ),
          child: pw.Column(
            children: [
              // Grand Total Row
              _buildTotalRow(
                'Grand Total',
                'Rs. ${grandTotal.toStringAsFixed(2)}',
                isHeader: true,
              ),
              // Advance Paid Row
              _buildTotalRow(
                'Advance Paid',
                '(-) Rs. ${advancePaid.toStringAsFixed(2)}',
              ),
              // Balance Due Row
              _buildTotalRow(
                balanceAmount > 0 ? 'Balance Due' : 'Paid in Full',
                'Rs. ${balanceAmount.toStringAsFixed(2)}',
                isHighlighted: true,
                isPositive: balanceAmount <= 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper: Build Total Row
  static pw.Widget _buildTotalRow(
    String label,
    String value, {
    bool isHeader = false,
    bool isHighlighted = false,
    bool isPositive = false,
  }) {
    PdfColor bgColor = PdfColors.white;
    PdfColor textColor = PdfColors.grey800;

    if (isHeader) {
      bgColor = PdfColors.grey200;
      textColor = PdfColors.grey900;
    } else if (isHighlighted) {
      bgColor = isPositive ? PdfColors.green50 : PdfColors.grey100;
      textColor = isPositive ? PdfColors.green800 : PdfColors.grey900;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: pw.BoxDecoration(
        color: bgColor,
        border: const pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isHeader || isHighlighted ? 9 : 8,
              fontWeight: isHeader || isHighlighted
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
              color: textColor,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isHeader || isHighlighted ? 10 : 9,
              fontWeight: isHeader || isHighlighted
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Build Customer Notes Section
  static pw.Widget _buildCustomerNotesSection(ServiceOrder order) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
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
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            order.notes!,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  // Build Mechanic Notes Section
  static pw.Widget _buildMechanicNotesSection(ServiceOrder order) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.blue200, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'MECHANIC NOTES',
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            order.mechanicNotes!,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
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
        pw.SizedBox(height: 6),
        // Thank You & Signature
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Thank You
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'Thank you for your business!',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'For queries: +91 80152 52501',
                    style: const pw.TextStyle(
                        fontSize: 7, color: PdfColors.grey600),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 20),
            // Signature
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.SizedBox(height: 15),
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
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Helper: Build Table Header Cell
  static pw.Widget _buildTableHeaderCell(String text, {PdfColor? color}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: color ?? PdfColors.white,
        ),
      ),
    );
  }

  // Helper: Build Table Data Cell
  static pw.Widget _buildTableDataCell(String text,
      {bool bold = false, pw.Alignment? alignment, bool isPrice = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      alignment: alignment ?? (isPrice ? pw.Alignment.center : null),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: isPrice ? pw.TextAlign.center : pw.TextAlign.left,
      ),
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
