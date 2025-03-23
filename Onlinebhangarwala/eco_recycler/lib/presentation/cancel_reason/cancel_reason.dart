import 'dart:convert';
import 'package:eco_recycler/presentation/pickup/upcoming_pickup.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:flutter/material.dart';

class CancellationReasonScreen extends StatefulWidget {
  final String pickupId;

  const CancellationReasonScreen({required this.pickupId, Key? key})
      : super(key: key);

  @override
  _CancellationReasonScreenState createState() =>
      _CancellationReasonScreenState();
}

class _CancellationReasonScreenState extends State<CancellationReasonScreen> {
  String? _selectedReason;

  @override
  Widget build(BuildContext context) {
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
          'Reason For Cancellation',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRadioOption('Too far from my location.'),
                  Divider(
                    thickness: 0.8,
                    color: Colors.white,
                  ),
                  _buildRadioOption('Time Constraints, due to schedule.'),
                  Divider(
                    thickness: 0.8,
                    color: Colors.white,
                  ),
                  _buildRadioOption('Vehicle Problem'),
                  Divider(
                    thickness: 0.8,
                    color: Colors.white,
                  ),
                  _buildRadioOption('On leave, that day'),
                  Divider(
                    thickness: 0.8,
                    color: Colors.white,
                  ),
                  _buildRadioOption('Other'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedReason != null
                    ? () {
                        _showConfirmationDialog(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5663FF), // Button color
                  minimumSize:
                      const Size(double.infinity, 50), // Full-width button
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String reason) {
    return Center(
      child: RadioListTile<String>(
        value: reason,
        groupValue: _selectedReason,
        activeColor: const Color(0xFF5663FF), // Set the active color to blue
        onChanged: (value) {
          setState(() {
            _selectedReason = value;
          });
        },
        title: Text(reason, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Reject Pick Up Request ?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Handle rejection logic here
                    final ApiService apiService = ApiService();

                    final data = {
                      'id': widget.pickupId,
                      'reason': _selectedReason
                    };

                    final response = await apiService.RejectOrder(data);
                    final responseBody = json.decode(response.body);

                    print('Request rejected with reason: $_selectedReason');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpcomingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5663FF), // Button color
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Yes, Reject',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
