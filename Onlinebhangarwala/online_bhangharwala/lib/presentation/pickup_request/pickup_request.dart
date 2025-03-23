import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_bhangharwala/presentation/pickup_request/completedpickup.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/track_pickup/track_pickup.dart';
import 'completecancelled.dart';

class PickupRequestsScreen extends StatefulWidget {
  @override
  _PickupRequestsScreenState createState() => _PickupRequestsScreenState();
}

class _PickupRequestsScreenState extends State<PickupRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white, // Change the indicator color to white
          indicatorWeight: 2, // Adjust the thickness of the indicator line
          labelColor: Colors.white, // Active tab text color
          unselectedLabelColor: Colors.grey, // Inactive tab text color
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed & \nCancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UpcomingTab(),
          CompletedCancelledRequestsTab(),
        ],
      ),
    );
  }
}

String formatPickupDate(String pickupDate) {
  DateTime parsedDate = DateTime.parse(pickupDate);
  return DateFormat('d, MMMM yyyy').format(parsedDate);
}

class UpcomingTab extends StatelessWidget {
  final ApiService apiService = ApiService();

  Future<List<dynamic>> fetchUpcomingPickups() async {
    final response = await apiService.Mypickups();
    final data = json.decode(response.body);
    print(data);
    return data['pickdata']; // Assuming this returns a list of pickups
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchUpcomingPickups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching data.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No upcoming pickups.'));
        }

        final upcomingPickups = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: upcomingPickups.length,
          itemBuilder: (context, index) {
            final pickup = upcomingPickups[index];

            return PickupRequestItemUpcoming(
              id: pickup['id'].toString(),
              date: formatPickupDate(pickup['pick_up_date']),
              timeRange: pickup['time_slot'],
              isCompleted:
                  pickup['status'] == null ? false : true, // Upcoming pickups
            );
          },
        );
      },
    );
  }
}

class PickupRequestItemUpcoming extends StatelessWidget {
  final String id;
  final String date;
  final String timeRange;
  final bool isCompleted;

  PickupRequestItemUpcoming({
    required this.id,
    required this.date,
    required this.timeRange,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackPickupRequestPage(
              pickupId: id,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.transparent, // Background color
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: $id',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    date,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    timeRange,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.refresh, color: Colors.orange, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompletedCancelledRequestsTab extends StatelessWidget {
  final ApiService apiService = ApiService();

  Future<List<dynamic>> fetchUpcomingPickups() async {
    final response = await apiService.Completecancel();
    final data = json.decode(response.body);
    print(data);
    return data['pickdata']; // Ensure this returns a list of pickups
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchUpcomingPickups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No requests available.'));
        } else {
          final requests = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return PickupRequestItem(
                id: request['id'].toString(),
                date: formatPickupDate(request['pick_up_date']),
                status: request['status'] == "2" ? 'cancelled' : 'completed',
              );
            },
          );
        }
      },
    );
  }
}

class PickupRequestItem extends StatelessWidget {
  final String id;
  final String date;
  final String status;

  PickupRequestItem({
    required this.id,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(status);
        status == 'completed'
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
                  builder: (context) => CompleteCancelled(
                    pickupId: id,
                  ),
                ),
              );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        color: const Color(0xFF0B234F), // Background color
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: $id',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        date,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                status == 'completed'
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: status == 'completed' ? Colors.green : Colors.red,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
