import 'dart:convert';

import 'package:eco_recycler/presentation/home/home.dart';
import 'package:eco_recycler/presentation/pickup/all_pickups.dart';
import 'package:eco_recycler/presentation/pickup/completed_pickup.dart';
import 'package:eco_recycler/presentation/pickup/upcoming_pickup.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:eco_recycler/widgets/app_bar/pickup_app_bar.dart';
import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String pickupId;
  final double couponAmount;
  final double itemTotal;
  final bool couponApplied;
  final String pickupdate;
  final String pickuptime;
  final String name;
  final String address;
  final List<int> subcategoryIds;
  final List<Map<String, dynamic>> calculatedItems;

  const PaymentMethodScreen(
      {required this.pickupId,
      required this.couponAmount,
      required this.itemTotal,
      required this.couponApplied,
      required this.pickupdate,
      required this.pickuptime,
      required this.name,
      required this.address,
      required this.subcategoryIds,
      required this.calculatedItems,
      Key? key})
      : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'Online';
  bool _isSubmitting = false;

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PCustomAppBar(title: 'Payment Method', pickupId: widget.pickupId),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            _buildPaymentOptionCard('Online', Colors.blue, widget.itemTotal),
            SizedBox(height: 10),
            _buildPaymentOptionCard('Offline', Colors.blue, widget.itemTotal),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        setState(() {
                          _isSubmitting = true;
                        });

                        final ApiService apiService = ApiService();

                        final data = {
                          'arrayOfObjects': widget.calculatedItems,
                          'finalprice': widget.itemTotal,
                          'finalweight': 0,
                          'id': widget.pickupId,
                          'coupon_amount': widget.couponAmount,
                          'mainprice': _selectedPaymentMethod == 'Online'
                              ? (widget.itemTotal + (widget.itemTotal * 0.10))
                                  .toStringAsFixed(2)
                              : widget.itemTotal.toStringAsFixed(2),
                          'paymentmode': _selectedPaymentMethod,
                          'subcategory': widget.subcategoryIds,
                        };

                        try {
                          final response =
                              await apiService.CompleteOrderByEco(data);
                          final responseBody = json.decode(response.body);
                          print(responseBody);
                          if (response.statusCode == 200) {
                            if (responseBody["status_code"] == 200) {
                              final orderComplete =
                                  responseBody["ordercomplete"];
                              print(orderComplete);

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => CompletedScreen(
                              //         pickupId: widget.pickupId),
                              //   ),
                              // );
                              //
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            } else {
                              _showErrorSnackbar('Invalid pickup ID received.');
                            }
                          } else {
                            _showErrorSnackbar(
                                'Failed to submit form. Please try again.');
                          }
                        } catch (e) {
                          _showErrorSnackbar('Error occurred: $e');
                        } finally {
                          setState(() {
                            _isSubmitting = false;
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _isSubmitting
                      ? Colors.grey
                      : Color(0xFF5663FF), // Disable color if submitting
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isSubmitting ? 'Processing...' : 'Proceed',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptionCard(
      String paymentMethod, Color color, double itemTotal) {
    return Card(
      color: _selectedPaymentMethod == paymentMethod ? color : Colors.white,
      elevation: _selectedPaymentMethod == paymentMethod ? 5 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: RadioListTile<String>(
        value: paymentMethod,
        groupValue: _selectedPaymentMethod,
        activeColor: Colors.blue,
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(paymentMethod, style: TextStyle(fontSize: 16)),
            Text(
              '₹ ${paymentMethod == 'Online' ? (itemTotal + (itemTotal * 0.10)).toStringAsFixed(2) : itemTotal.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: paymentMethod == 'Online'
            ? Text(
                '10% extra on total amount by choosing online payment.',
                style: TextStyle(color: Colors.black87, fontSize: 12),
              )
            : null,
      ),
    );
  }
}
