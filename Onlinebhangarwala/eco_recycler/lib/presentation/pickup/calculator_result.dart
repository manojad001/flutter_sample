import 'package:eco_recycler/presentation/cancel_reason/cancel_reason.dart';
import 'package:eco_recycler/presentation/pickup/final_confirmation.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:eco_recycler/widgets/app_bar/pickup_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculationResults extends StatefulWidget {
  final String pickupId;
  final List<Map<String, dynamic>> calculatedItems;
  final double totalAmount;
  final String pickupdate;
  final String pickuptime;
  final String name;
  final String address;
  final List<int> subcategoryIds;

  CalculationResults({
    required this.pickupId,
    required this.subcategoryIds,
    required this.calculatedItems,
    required this.totalAmount,
    required this.pickupdate,
    required this.pickuptime,
    required this.name,
    required this.address,
  });

  @override
  State<CalculationResults> createState() => _CalculationResultsState();
}

class _CalculationResultsState extends State<CalculationResults> {
  final TextEditingController _couponController = TextEditingController();
  bool _isLoading = false;
  String _couponError = '';
  String _couponId = '';

  @override
  void initState() {
    super.initState();
  }

  Future<bool> validateCoupon(String couponCode) async {
    try {
      final ApiService apiService = ApiService();
      final response = await apiService.checkCoupon(couponCode,
          (widget.totalAmount).toString()); // Pass the total amount here
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        if (data['status'] == 'valid') {
          _couponId = data['coupon']['id'].toString();
          return true;
        } else {
          setState(() {
            _couponError = data['message'];
          });
        }
      } else {
        setState(() {
          _couponError = data['message'];
        });
      }
    } catch (e) {
      setState(() {
        _couponError = 'Error validating coupon: $e';
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PCustomAppBar(title: 'Scrap Details', pickupId: widget.pickupId),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06193D), Color(0xFF0A285E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Scrap Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.calculatedItems.length,
                itemBuilder: (context, index) {
                  final item = widget.calculatedItems[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['subcat'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          '${item['kg']} kg',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white54, thickness: 0.8),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '₹ ${widget.totalAmount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Apply Coupon',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _couponController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                hintText: 'Enter coupon code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (_couponError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _couponError,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                  _couponError = '';
                });

                bool isCouponValid = true;
                if (_couponController.text.isNotEmpty) {
                  isCouponValid = await validateCoupon(_couponController.text);
                }

                setState(() {
                  _isLoading = false;
                });

                if (isCouponValid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalConfirmationScreen(
                        pickupId: widget.pickupId,
                        calculatedItems: widget.calculatedItems,
                        subcategoryIds: widget.subcategoryIds,
                        itemTotal: widget.totalAmount,
                        couponApplied: _couponController.text.isNotEmpty,
                        couponId: _couponId, // Pass the coupon ID here
                        pickupdate: widget.pickupdate,
                        pickuptime: widget.pickuptime,
                        name: widget.name,
                        address: widget.address,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF5663FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
