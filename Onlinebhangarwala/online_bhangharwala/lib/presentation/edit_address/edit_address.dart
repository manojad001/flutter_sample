import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/add_address/add_address.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';

class EditAddress extends StatefulWidget {
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  int selectedAddressId = -1;
  bool _isLoading = true;
  List<Map<String, dynamic>> addresses = [];

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

      if (responseBody['address'] != null) {
        List<dynamic> addressList = responseBody['address'];
        setState(() {
          addresses = addressList
              .map((address) => {
                    'id': address['id'],
                    'title': address['address_type'] ?? 'No Title',
                    'address': (address['address'] ?? '') +
                        "\n" +
                        (address['landmark'] ?? '') +
                        " " +
                        (address['pin'] ?? ''),
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Failed to load addresses");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPopupMenu(BuildContext context, int index) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(200, 40, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
            onTap: () {
              int idToEdit = addresses[index]['id'];
              print('Edit address with ID: $idToEdit');
              String addressId = idToEdit.toString();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddAdress(addressId: addressId)),
              );

              // Navigator.of(context).pop();
              // Handle edit functionality here
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () async {
              Navigator.of(context).pop();

              int idToDelete = addresses[index]['id'];
              final ApiService apiService = ApiService();
              final response = await apiService.DeleteAddress(idToDelete);

              if (response.statusCode == 200) {
                final response1 = json.decode(response.body);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted successfully!')),
                );
              }
              setState(() {
                int idToDelete = addresses[index]['id'];
                print('Deleting address with ID: $idToDelete');
                addresses.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }

  String _getTitle(int addressType) {
    switch (addressType) {
      case 1:
        return 'Home';
      case 2:
        return 'Business';
      case 3:
        return 'Friend and Family';
      case 4:
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: Colors.blue[900],
                            ),
                            title: Text(_getTitle(addresses[index]['title'])),
                            subtitle: Text(
                                addresses[index]['address'] ?? 'No Address'),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                _showPopupMenu(context, index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // Handle add new location functionality here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddAdress()),
                      );
                    },
                    child: Text(
                      'Add New Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
