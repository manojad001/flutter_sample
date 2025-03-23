import 'package:eco_recycler/presentation/cancel_reason/cancel_reason.dart';
import 'package:eco_recycler/presentation/pickup/calculator.dart';
import 'package:eco_recycler/widgets/app_bar/pickup_app_bar.dart';
import 'package:flutter/material.dart';

class ConfirmationScreen extends StatefulWidget {
  final String pickupId;
  final String pickupdate;
  final String pickuptime;
  final String name;
  final String address;

  ConfirmationScreen({
    required this.pickupId,
    required this.pickupdate,
    required this.pickuptime,
    required this.name,
    required this.address,
  });
  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PCustomAppBar(title: 'Confirmation', pickupId: widget.pickupId),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'OB ID : ${widget.pickupId}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '${widget.name}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  '${widget.pickupdate}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  '${widget.pickuptime}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${widget.address}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white54,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.location_pin,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Reached Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Processed to next step, which is weighing scrap',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5663FF), // Blue button color
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Calculator(
                        pickupId: widget.pickupId, // Pass the ID here
                        pickupdate: widget.pickupdate,
                        pickuptime: widget.pickuptime,
                        name: widget.name,
                        address: widget.address,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Weigh Scrap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
