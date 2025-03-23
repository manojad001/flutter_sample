import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_bhangharwala/core/utils/image_constant.dart';
import 'package:online_bhangharwala/presentation/confirmation/confirmation.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String pickUp;
  final String timeSlot;
  final String instructions;
  final String addrType;
  final String address;
  final String landmark;
  final String pin;

  PaymentMethodScreen({
    required this.pickUp,
    required this.timeSlot,
    required this.instructions,
    required this.addrType,
    required this.address,
    required this.landmark,
    required this.pin,
  });

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedPaymentMode; // Track the selected payment mode
  bool _isSubmitting = false; // Track submission state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Payment Method', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Select money acceptance mode',
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  PaymentModeCard(
                    imagePath: ImageConstant.upi,
                    title: 'Online',
                    description: 'Get money in UPI by our pickup executive.',
                    isSelected: selectedPaymentMode == 'Online',
                    onTap: () => _onPaymentModeSelected('Online'),
                  ),
                  PaymentModeCard(
                    imagePath: ImageConstant.cash,
                    title: 'Cash',
                    description: 'Get money in cash by our pickup executive.',
                    isSelected: selectedPaymentMode == 'Offline',
                    onTap: () => _onPaymentModeSelected('Offline'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedPaymentMode != null && !_isSubmitting
                  ? _submit
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue.shade900,
              ),
              child: Text(
                _isSubmitting ? 'Submitting...' : 'Submit',
                style: TextStyle(
                  color:
                      selectedPaymentMode != null ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF06193D),
    );
  }

  void _onPaymentModeSelected(String mode) {
    setState(() {
      selectedPaymentMode = mode;
    });
  }

  String _parseDate(String pickUpDate) {
    // Assuming pickUpDate is in the format "12 August, Monday"
    final format = DateFormat('dd MMMM, EEEE'); // Input format without the year

    // Parse the provided date with the current year
    final currentYear = DateTime.now().year;
    final pickUpDateWithYear = '$pickUpDate, $currentYear';

    final formatWithYear =
        DateFormat('dd MMMM, EEEE, yyyy'); // Adjusted format with the year
    final parsedDate = formatWithYear.parse(pickUpDateWithYear);

    return DateFormat('yyyy-MM-dd')
        .format(parsedDate); // Format to "2024-08-12"
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true; // Set the button to be disabled
    });

    final ApiService apiService = ApiService();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final parsedDate = _parseDate(widget.pickUp);
    print(parsedDate);
    final data = {
      'user_id': userId,
      'Address': widget.address,
      'landmark': widget.landmark,
      'pin': widget.pin,
      'Addresstype': widget.addrType,
      'DaySlot': parsedDate,
      'TimeSlot': widget.timeSlot,
      'instructions': widget.instructions,
      'Money': selectedPaymentMode,
    };

    try {
      final response = await apiService.Pickup(data);
      final response1 = json.decode(response.body);

      if (response.statusCode == 200) {
        if (response1["status_code"] == 200) {
          final pickupId = response1["pickdata"];
          print(pickupId.toString());

          // Navigate to the ConfirmationScreen and pass the pickupId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmationScreen(
                pickupId: pickupId.toString(), // Pass the ID here
              ),
            ),
          ).then((_) {
            setState(() {
              _isSubmitting = false; // Re-enable the button when returning
            });
          });
        } else {
          _showErrorSnackbar('Invalid pickup ID received.');
          setState(() {
            _isSubmitting = false; // Re-enable the button if there's an error
          });
        }
      } else {
        _showErrorSnackbar('Failed to submit form. Please try again.');
        setState(() {
          _isSubmitting = false; // Re-enable the button if there's an error
        });
      }
    } catch (e) {
      _showErrorSnackbar('Error occurred: $e');
      setState(() {
        _isSubmitting = false; // Re-enable the button if there's an error
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class PaymentModeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentModeCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.blue.shade100 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: isSelected ? Colors.blue.shade800 : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imagePath,
                height: 30,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
