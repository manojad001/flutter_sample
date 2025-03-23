import 'dart:convert';
import 'package:eco_recycler/core/utils/image_constant.dart';
import 'package:eco_recycler/presentation/pickup/pickup_details.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingScreen extends StatefulWidget {
  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  bool showToday = true; // Tracks the active tab (Today or Tomorrow)
  List<Map<String, dynamic>> todayPickups = [];
  List<Map<String, dynamic>> tomorrowPickups = [];
  bool isLoading = true; // Shows a loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    fetchTodayPickups(); // Fetch data for today by default
  }

  Future<void> fetchTodayPickups() async {
    setState(() {
      isLoading = true;
    });

    try {
      final ApiService apiService = ApiService();
      final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Fetch today's data
      final todayResponse = await apiService.GetEcoRecyclerPickUP();
      final todayJson = json.decode(todayResponse.body);
      print(todayJson);
      setState(() {
        todayPickups = List<Map<String, dynamic>>.from(todayJson['pickEco']);
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchTomorrowPickups() async {
    setState(() {
      isLoading = true;
    });

    try {
      final ApiService apiService = ApiService();
      final tomorrowDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(Duration(days: 1)));

      print(tomorrowDate);

      // Fetch tomorrow's data
      final tomorrowResponse = await apiService.DateWiseOrder(tomorrowDate);
      final tomorrowJson = json.decode(tomorrowResponse.body);

      setState(() {
        tomorrowPickups =
            List<Map<String, dynamic>>.from(tomorrowJson['pickEco']);
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
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
          'Upcoming Pickups',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDateSwitcher(),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildPickupList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSwitcher() {
    return Row(
      children: [
        _buildSwitcherButton('Today', isActive: showToday, onPressed: () {
          setState(() {
            showToday = true;
          });
          fetchTodayPickups(); // Fetch today's data when switched to Today tab
        }),
        const SizedBox(width: 8),
        _buildSwitcherButton('Tomorrow', isActive: !showToday, onPressed: () {
          setState(() {
            showToday = false;
          });
          fetchTomorrowPickups(); // Fetch tomorrow's data when switched to Tomorrow tab
        }),
      ],
    );
  }

  Widget _buildSwitcherButton(String title,
      {required bool isActive, required VoidCallback onPressed}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.blue[900] : Colors.grey[300],
          foregroundColor: isActive ? Colors.white : Colors.black,
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildPickupList() {
    final pickups = showToday ? todayPickups : tomorrowPickups;

    if (pickups.isEmpty) {
      return _buildNoPickupsWidget();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: pickups.length,
        itemBuilder: (context, index) {
          final pickup = pickups[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PickUpDetailsScreen(
                    pickupId: pickup["id"].toString(), // Pass the ID here
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: PickupItem(
                id: pickup['id'].toString(),
                pinCode: pickup['pin'].toString(),
                date: pickup['pick_up_date'] ?? 'N/A',
                time: pickup['time_slot'] ?? 'N/A',
                status: pickup['status'] ?? 'N/A',
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildNoPickupsWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 32),
        Text(
          'No Pick Ups Assign',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 32),
        Container(
          width: 200,
          height: 200,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset(
              ImageConstant.noAssignPickup,
            ),
          ),
        ),
      ],
    ),
  );
}

class PickupItem extends StatelessWidget {
  final String id;
  final String pinCode;
  final String date;
  final String time;
  final String status;

  const PickupItem({
    required this.id,
    required this.pinCode,
    required this.date,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status == '2' ? Colors.red[50] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: status == '2' ? Colors.red : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'OB ID: $id',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              if (status == '2') const Icon(Icons.refresh, color: Colors.red),
              if (status == '0')
                const Icon(Icons.access_time, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 8),
          Text('Pin Code: $pinCode',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.black),
              SizedBox(width: 4),
              Text('$date'),
              SizedBox(width: 16),
              Icon(Icons.access_time, color: Colors.black),
              SizedBox(width: 4),
              Text('$time'),
            ],
          ),
        ],
      ),
    );
  }
}
