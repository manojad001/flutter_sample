import 'dart:convert';
import 'package:eco_recycler/presentation/pickup/cancelled_pickup.dart';
import 'package:eco_recycler/presentation/pickup/completed_pickup.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:flutter/material.dart';

class AllpickupScreen extends StatefulWidget {
  @override
  State<AllpickupScreen> createState() => _AllpickupScreenState();
}

class _AllpickupScreenState extends State<AllpickupScreen> {
  List<dynamic> pickEcoData = [];
  List<dynamic> filteredPickups = [];
  String? totalPickup;
  String? completPickup;
  String? pendingPickup;
  String? rejectedPickup;
  String selectedFilter = "All";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllPickups();
  }

  Future<void> fetchAllPickups() async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.Allpickups();
      final responseBody = json.decode(response.body);
      setState(() {
        pickEcoData = responseBody['pickEco'] ?? [];
        filteredPickups = pickEcoData; // Initially show all pickups
        totalPickup = responseBody['totalassign']?.toString() ?? '0';
        completPickup = responseBody['complete']?.toString() ?? '0';
        pendingPickup = responseBody['pending']?.toString() ?? '0';
        rejectedPickup = responseBody['rejected']?.toString() ?? '0';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPickups(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == "All") {
        filteredPickups = pickEcoData;
      } else if (filter == "Completed") {
        filteredPickups =
            pickEcoData.where((pickup) => pickup['status'] == "1").toList();
      } else if (filter == "Rejected") {
        filteredPickups =
            pickEcoData.where((pickup) => pickup['status'] == "3").toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pick Up History',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Dropdown

                  const SizedBox(height: 10),
                  // Stats Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Total Pick Ups', totalPickup.toString()),
                      _buildStatCard(
                          'Completed Pick Ups', completPickup.toString()),
                      _buildStatCard(
                          'Pending Pick Ups', pendingPickup.toString()),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                          'Rejected Pick Ups', rejectedPickup.toString()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'All Pick Ups',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(width: 20),
                      // const Text(
                      //   'Filter by Status:',
                      //   style: TextStyle(color: Colors.white, fontSize: 16),
                      // ),
                      DropdownButton<String>(
                        value: selectedFilter,
                        items: <String>["All", "Completed", "Rejected"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: value == selectedFilter
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            filterPickups(newValue);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // List of Pickups
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredPickups.length,
                      itemBuilder: (context, index) {
                        final pickup = filteredPickups[index];
                        return _buildPickUpCard(
                          context,
                          id: pickup['id'].toString(),
                          name: pickup['address'] ?? 'Unknown',
                          pinCode: pickup['pin'].toString(),
                          date: pickup['pick_up_date'] ?? 'N/A',
                          time: pickup['time_slot'] ?? 'N/A',
                          status: _getStatusText(pickup['status']),
                          statusColor: _getStatusColor(pickup['status']),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPickUpCard(
    BuildContext context, {
    required String id,
    required String name,
    required String pinCode,
    required String date,
    required String time,
    required String status,
    required Color statusColor,
  }) {
    return GestureDetector(
      onTap: () {
        status == "Completed"
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedScreen(
                    pickupId: id,
                  ),
                ),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CancelledScreen(
                    pickupId: id,
                  ),
                ),
              );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OB ID: $id',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        status == 'Completed'
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: statusColor,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(name),
              const SizedBox(height: 5),
              Text('Pin Code: $pinCode'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(date),
                  const SizedBox(width: 20),
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(time),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case "1":
        return 'Completed';
      case "2":
        return 'Pending';
      case "3":
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "1":
        return Colors.green;
      case "2":
        return Colors.orange;
      case "3":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
