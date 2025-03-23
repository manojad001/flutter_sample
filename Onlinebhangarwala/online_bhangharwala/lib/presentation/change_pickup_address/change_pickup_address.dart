import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_bhangharwala/presentation/add_address/add_address.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePickupAddressScreen extends StatefulWidget {
  @override
  _ChangePickupAddressScreenState createState() =>
      _ChangePickupAddressScreenState();
}

class _ChangePickupAddressScreenState extends State<ChangePickupAddressScreen> {
  List<Address> addresses = [];
  int selectedAddressId = -1;
  bool _isLoading = true; // Add a loading state variable

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    final ApiService apiService = ApiService();
    final response = await apiService.GetUserAddress();

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      List<dynamic> addressList = responseBody['address'];
      setState(() {
        addresses = addressList.map((json) => Address.fromJson(json)).toList();
        _isLoading = false; // Set loading to false once data is loaded
      });
    } else {
      // Handle error or show a message to the user
      print("Failed to load addresses");
      setState(() {
        _isLoading = false; // Set loading to false even on error
      });
    }
  }

  void _updateSelectedAddress(int id) {
    setState(() {
      selectedAddressId = id;
    });
  }

  Future<void> _updateAddress() async {
    if (selectedAddressId != -1) {
      // Get the selected address
      Address? selectedAddress = addresses.firstWhere(
          (address) => address.id == selectedAddressId,
          orElse: () => Address(id: -1, title: '', address: '', iconType: 0));

      if (selectedAddress.id != -1) {
        print('Selected Address: ${selectedAddress.address}');

        // Determine the address type and store it
        int addressTypeTitle;
        switch (selectedAddress.title) {
          case "Home":
            addressTypeTitle = 1;
            break;
          case "Business":
            addressTypeTitle = 2;
            break;
          case "Friend and Family":
            addressTypeTitle = 3;
            break;
          case "Other":
            addressTypeTitle = 4;
            break;
          default:
            addressTypeTitle = 0;
        }

        // Pop the screen to go back, passing `true` to indicate an update occurred
        Navigator.pop(context, {
          'address': selectedAddress.address.split(", ").first,
          'landmark': selectedAddress.address.split(", ")[1],
          'pin': selectedAddress.address.split(", ").last,
          'address_type': selectedAddress.title,
          'addrType': addressTypeTitle,
        });
      } else {
        print('No valid address found');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        title: const Text(
          'Change Pickup Address',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFF071533),
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // Show loader
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (addresses.isNotEmpty)
                    ...addresses.map((address) {
                      return Column(
                        children: [
                          AddressTile(
                            icon: _getIconFromType(address.iconType),
                            title: address.title,
                            address: address.address,
                            isSelected: selectedAddressId == address.id,
                            onTap: () => _updateSelectedAddress(address.id),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    }).toList(),
                  if (addresses.isEmpty)
                    const Center(
                      child: Text(
                        'No addresses available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: selectedAddressId != -1 ? _updateAddress : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3b61f4),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddAdress()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Text('Add New Location',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getIconFromType(int iconType) {
    switch (iconType) {
      case 1:
        return Icons.home;
      case 2:
        return Icons.business;
      case 3:
        return Icons.circle;
      case 4:
        return Icons.circle;
      default:
        return Icons.circle;
    }
  }
}

class AddressTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String address;
  final bool isSelected;
  final VoidCallback onTap;

  AddressTile({
    required this.icon,
    required this.title,
    required this.address,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff3b61f4) : const Color(0xFF0C2340),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    address,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Address {
  final int id;
  final String title;
  final String address;
  final int iconType;

  Address({
    required this.id,
    required this.title,
    required this.address,
    required this.iconType,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    String addressTypeTitle;
    if (json['address_type'] == 1) {
      addressTypeTitle = 'Home';
    } else if (json['address_type'] == 2) {
      addressTypeTitle = 'Business';
    } else if (json['address_type'] == 3) {
      addressTypeTitle = 'Friend and Family';
    } else if (json['address_type'] == 4) {
      addressTypeTitle = 'Other';
    } else {
      addressTypeTitle = 'Unknown';
    }

    return Address(
      id: json['id'],
      title: addressTypeTitle,
      address: (json['address'] ?? '') +
          (json['landmark']?.isNotEmpty == true
              ? ', ' + json['landmark']
              : '') +
          (json['pin']?.isNotEmpty == true ? ', ' + json['pin'] : ''),
      iconType: json['address_type'],
    );
  }
}
