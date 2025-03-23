import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';

class CompleteCancelled extends StatefulWidget {
  final String pickupId;

  CompleteCancelled({required this.pickupId});

  @override
  State<CompleteCancelled> createState() => _CompleteCancelledState();
}

class _CompleteCancelledState extends State<CompleteCancelled> {
  final ApiService apiService = ApiService();
  Future<Map<String, dynamic>>? pickupDetails;

  @override
  void initState() {
    super.initState();
    pickupDetails = fetchPickupDetails(widget.pickupId);
  }

  Future<Map<String, dynamic>> fetchPickupDetails(String pickupId) async {
    final response = await apiService.GetPickUPDetails(widget.pickupId);
    print(response);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load pickup details');
    }
  }

  String getAddressType(Map<String, dynamic> data) {
    String addressType = data['userdetails'][0]['address_type'].toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        title: const Text(
          'Pickup Request',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: pickupDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF06193D),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cancelled Pickups',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cancellation reason',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data['userdetails'][0]['cancel_reason']?.toString() ??
                        'No reason provided',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.white, // White color divider
                    thickness: 1.0, // Optional thickness
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expected Pickup',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['userdetails'][0]['pick_up_date'] ??
                                'Unknown date',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            data['userdetails'][0]['time_slot']?.toString() ??
                                'Unknown time',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Request ID',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['userdetails'][0]['id']?.toString() ??
                                'Unknown ID',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.white, // White color divider
                    thickness: 1.0, // Optional thickness
                  ),
                  // const SizedBox(height: 16),
                  // const Text(
                  //   'Scrap items',
                  //   style: TextStyle(
                  //       color: Colors.white, fontWeight: FontWeight.bold),
                  // ),
                  //Divider()
                  // Text(
                  //   data['scrap_items'] != null
                  //       ? (data['scrap_items'] as List<dynamic>).join(', ')
                  //       : 'No items listed',
                  //   style: const TextStyle(color: Colors.white),
                  // ),
                  SizedBox(height: 16),
                  Text(
                    "Address - ${getAddressType(data)}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['userdetails'][0]['address'] +
                            "\n" +
                            data['userdetails'][0]['landmark'] +
                            " " +
                            data['userdetails'][0]['pin'].toString() ??
                        'No address provided',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
