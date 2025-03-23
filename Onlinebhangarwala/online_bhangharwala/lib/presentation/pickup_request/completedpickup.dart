import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CompletedScreen extends StatefulWidget {
  final String pickupId;

  CompletedScreen({required this.pickupId});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  Map<String, dynamic>? userDetails;
  List<dynamic>? scrapDetails;

  @override
  void initState() {
    super.initState();
    CompletedPickup();
  }

  Future<void> CompletedPickup() async {
    final ApiService apiService = ApiService();
    final response = await apiService.GetPickUPDetails(widget.pickupId);
    final responseJson = json.decode(response.body);

    setState(() {
      // Retrieve user details
      userDetails = responseJson['userdetails']?.first;

      // Retrieve scrap details
      scrapDetails = responseJson['Scrspdetails'];
    });

    print(userDetails);
  }

  Future<void> _downloadReceipt() async {
    final pdf = pw.Document();
    final userDetails = this.userDetails!;
    final scrapDetails = this.scrapDetails!;
    final generatedDate = DateTime.now();
    final formattedDate =
        "${generatedDate.day}-${generatedDate.month}-${generatedDate.year}";

    // Calculate total scrap price
    double totalScrapPrice = 0;
    for (var scrap in scrapDetails) {
      totalScrapPrice += (scrap['totalprice'] as num)
          .toDouble(); // Ensure correct type conversion
    }

    // Calculate additional 10% if online payment
    double feeAmount = 0;
    if (userDetails['payment_mode'] == 'Online') {
      feeAmount = totalScrapPrice * 0.10;
    }

    final totalPaid = userDetails!['amount_paid'] ?? 0;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Online Bhangarwala',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueAccent,
                      ),
                    ),
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Date: $formattedDate',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  'Customer Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text('${userDetails['firstname']}'),
                pw.Text(
                    '${userDetails['address']}, ${userDetails['landmark']}'),
                pw.Text('OB ID: ${userDetails['id']}'),
                pw.Text('Pin Code: ${userDetails['pin']}'),
                pw.Text('Mobile: ${userDetails['mobile']}'),
                pw.Text('Payment Mode: ${userDetails['payment_mode']}'),
                pw.SizedBox(height: 24),
                pw.Text(
                  'Scrap Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Table.fromTextArray(
                  context: context,
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColors.blueAccent,
                  ),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellHeight: 30,
                  cellStyle: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.black,
                  ),
                  data: <List<String>>[
                    <String>[
                      'Item ID',
                      'Item',
                      'Weight',
                      'Price',
                      'Total Price'
                    ],
                    ...scrapDetails.map(
                      (scrap) => [
                        scrap['id'].toString(),
                        scrap['subcat'],
                        '${scrap['scrap_weight']} ${scrap['unit']}',
                        'Rs. ${scrap['scrap_price']}',
                        'Rs. ${scrap['totalprice']}',
                      ],
                    ),
                  ],
                ),
                if (userDetails['coupon_amount'] != null) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Coupon Used: Rs. ${userDetails['coupon_amount'].toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.orangeAccent,
                    ),
                  ),
                ],
                if (userDetails['payment_mode'] == 'Online') ...[
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'With online payment, 10% extra on the total amount Rs. ${feeAmount.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.redAccent,
                    ),
                  ),
                ],
                pw.SizedBox(height: 16),
                pw.Divider(color: PdfColors.grey),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Amount Paid: Rs. ${totalPaid}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;

    // Calculate the total amount from the scrap details
    scrapDetails?.forEach((scrap) {
      totalAmount += double.parse(scrap['totalprice'].toString());
    });

    // Calculate 10% of the total amount
    double tenPercentAmount =
        userDetails != null && userDetails!['actual_amount'] != null
            ? double.parse(userDetails!['actual_amount']) * 0.10
            : 0.00;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Pick Up History',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: userDetails == null
            ? Center(
                child:
                    CircularProgressIndicator()) // Show loader while data is being fetched
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Completed Pickups',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 28,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You have successfully completed this pick-up request.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Details Card
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OB ID : ${userDetails!['id']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Customer Name: ${userDetails!['firstname']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Date: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                userDetails!['pick_up_date'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Time: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                userDetails!['time_slot'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Pickup Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address Type: ${getAddressType(userDetails!['address_type'])}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${userDetails!['address']},\n${userDetails!['landmark']},\nPIN: ${userDetails!['pin'].toString()}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Payment Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...scrapDetails!.map((scrap) => PaymentRow(
                                label: scrap['subcat'],
                                amount: '₹ ${scrap['totalprice']}',
                              )),
                          SizedBox(height: 4),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          userDetails!['coupon_amount'] != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Coupon Used',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '₹ ${userDetails!["coupon_amount"]}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 4),
                          userDetails!['payment_mode'] == 'Online'
                              ? Row(
                                  children: [
                                    Text(
                                      'with online payment 10% extra \n on total amount',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 32),
                                    Text(
                                      '₹ ${tenPercentAmount.toStringAsFixed(2) ?? 0.0}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          Text(
                            'Total Amount Paid via ${userDetails!['payment_mode']}:  ₹ ${userDetails!['amount_paid']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        backgroundColor: Color(0xFF0056FF), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _downloadReceipt();
                        // Add your download receipt action here
                      },
                      child: Text(
                        'Download Receipt',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

String getAddressType(String addType) {
  String addressType = addType.toString();
  switch (addressType) {
    case "1":
      return 'Home';
    case "2":
      return 'Business';
    case "3":
      return 'Friend & Family';
    case "4":
      return 'Other';
    default:
      return 'Unknown';
  }
}

class PaymentRow extends StatelessWidget {
  final String label;
  final String amount;

  PaymentRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
