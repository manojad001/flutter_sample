import 'dart:convert';
import 'package:eco_recycler/presentation/pickup/payment.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:eco_recycler/widgets/app_bar/pickup_app_bar.dart';
import 'package:flutter/material.dart';

class FinalConfirmationScreen extends StatefulWidget {
  final String pickupId;
  final double itemTotal;
  final bool couponApplied;
  final String couponId;
  final String pickupdate;
  final String pickuptime;
  final String name;
  final String address;
  final List<int> subcategoryIds;
  final List<Map<String, dynamic>> calculatedItems;

  const FinalConfirmationScreen({
    required this.pickupId,
    required this.itemTotal,
    required this.couponApplied,
    required this.couponId,
    required this.pickupdate,
    required this.pickuptime,
    required this.name,
    required this.address,
    required this.subcategoryIds,
    required this.calculatedItems,
    Key? key,
  }) : super(key: key);

  @override
  State<FinalConfirmationScreen> createState() =>
      _FinalConfirmationScreenState();
}

class _FinalConfirmationScreenState extends State<FinalConfirmationScreen> {
  double? _amount;

  @override
  void initState() {
    super.initState();
    GetSpecifiCoupon();
  }

  Future<void> GetSpecifiCoupon() async {
    try {
      final ApiService apiService = ApiService();

      final response = await apiService.GetSpecifiCoupon(widget.couponId);
      final data = json.decode(response.body);

      final amount = data['coupon']?['amount'];
      double parsedAmount;

      if (amount is String) {
        parsedAmount = double.tryParse(amount) ?? 0.0;
      } else if (amount is num) {
        parsedAmount = amount.toDouble();
      } else {
        parsedAmount = 0.0;
      }

      setState(() {
        _amount = parsedAmount;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  double calculateTotalAmount() {
    // Calculate total amount considering the coupon
    if (widget.couponApplied && _amount != null) {
      final total = widget.itemTotal + _amount!;
      return double.parse(total.toStringAsFixed(2));
    }
    return double.parse(widget.itemTotal.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = calculateTotalAmount();

    return Scaffold(
      appBar: PCustomAppBar(title: 'Confirmation', pickupId: widget.pickupId),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OB ID : ${widget.pickupId}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('${widget.name}'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 8),
                      Text('${widget.pickupdate}'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16),
                      SizedBox(width: 8),
                      Text('${widget.pickuptime}'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${widget.address}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items Total',
                  style: TextStyle(color: Colors.white),
                ),
                Text('₹ ${widget.itemTotal}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            Divider(
              color: Colors.white,
            ),
            widget.couponApplied
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Coupon Applied',
                          style: TextStyle(color: Colors.white)),
                      Text('₹ ${_amount}',
                          style: TextStyle(color: Colors.white)),
                    ],
                  )
                : SizedBox.shrink(),
            widget.couponApplied ? Divider() : SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '₹ $totalAmount',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodScreen(
                        pickupId: widget.pickupId,
                        calculatedItems: widget.calculatedItems,
                        subcategoryIds: widget.subcategoryIds,
                        itemTotal: totalAmount,
                        couponAmount: _amount ?? 0.0,
                        couponApplied: widget.couponApplied,
                        pickupdate: widget.pickupdate,
                        pickuptime: widget.pickuptime,
                        name: widget.name,
                        address: widget.address,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5663FF),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Payment Method',
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
